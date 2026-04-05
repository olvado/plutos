import React, { useState } from "react";
import {
  Badge,
  Box,
  Button,
  Flex,
  Heading,
  HStack,
  NativeSelect,
  Spinner,
  Stack,
  Table,
  Text,
} from "@chakra-ui/react";
import { useParams, useNavigate } from "react-router-dom";
import {
  useGetAccountQuery,
  useDeleteAccountMutation,
  useDeleteTransactionMutation,
  GetAccountQuery,
} from "../../graphql/generated";
import AccountForm from "../components/AccountForm";
import TransactionForm from "../components/TransactionForm";
import DeleteConfirmation from "../components/DeleteConfirmation";

const ACCOUNT_TYPE_LABELS: Record<string, string> = {
  SAVINGS: "Savings",
  CASH_ISA: "Cash ISA",
  INVESTMENT_ISA: "Investment ISA",
  LIFETIME_ISA: "Lifetime ISA",
};

const TRANSACTION_TYPE_LABELS: Record<string, string> = {
  DEPOSIT: "Deposit",
  WITHDRAWAL: "Withdrawal",
  VARIANCE: "Variance",
  INTEREST: "Interest",
};

const TRANSACTION_TYPE_COLORS: Record<string, string> = {
  DEPOSIT: "green",
  WITHDRAWAL: "red",
  VARIANCE: "purple",
  INTEREST: "blue",
};

function formatGBP(amount: number): string {
  return new Intl.NumberFormat("en-GB", { style: "currency", currency: "GBP" }).format(amount);
}

function formatDate(iso: string): string {
  return new Date(iso).toLocaleDateString("en-GB", {
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

type Transaction = NonNullable<GetAccountQuery["account"]["transactions"]>[number];

type SortKey = "date" | "amount";
type SortDir = "asc" | "desc";

export default function AccountDetailPage() {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const accountId = parseInt(id ?? "0", 10);

  const [typeFilter, setTypeFilter] = useState<string>("");
  const [sortKey, setSortKey] = useState<SortKey>("date");
  const [sortDir, setSortDir] = useState<SortDir>("desc");
  const [editAccountOpen, setEditAccountOpen] = useState(false);
  const [addTxOpen, setAddTxOpen] = useState(false);
  const [editTx, setEditTx] = useState<Transaction | null>(null);
  const [deleteTx, setDeleteTx] = useState<Transaction | null>(null);
  const [deleteAccountOpen, setDeleteAccountOpen] = useState(false);

  const { data, loading, refetch } = useGetAccountQuery({ variables: { id: accountId } });
  const [deleteAccount, { loading: deletingAccount }] = useDeleteAccountMutation();
  const [deleteTransaction, { loading: deletingTx }] = useDeleteTransactionMutation();

  if (loading) {
    return (
      <Flex justify="center" py={16}>
        <Spinner />
      </Flex>
    );
  }

  if (!data?.account) {
    return <Text color="fg.muted">Account not found.</Text>;
  }

  const account = data.account;
  const balance = account.balance?.balance ?? 0;

  const transactions = account.transactions
    .filter(tx => !typeFilter || tx.type === typeFilter)
    .slice()
    .sort((a, b) => {
      const aVal = sortKey === "date" ? new Date(a.date).getTime() : a.amount;
      const bVal = sortKey === "date" ? new Date(b.date).getTime() : b.amount;
      return sortDir === "asc" ? aVal - bVal : bVal - aVal;
    });

  function toggleSort(key: SortKey) {
    if (sortKey === key) {
      setSortDir(d => (d === "asc" ? "desc" : "asc"));
    } else {
      setSortKey(key);
      setSortDir("desc");
    }
  }

  async function handleDeleteAccount() {
    await deleteAccount({ variables: { input: { id: accountId } } });
    navigate("/dashboard");
  }

  async function handleDeleteTransaction() {
    if (!deleteTx) return;
    await deleteTransaction({ variables: { input: { id: deleteTx.id } } });
    setDeleteTx(null);
    refetch();
  }

  return (
    <Stack gap={6}>
      {/* Header */}
      <Flex align="flex-start" justify="space-between" wrap="wrap" gap={3}>
        <Stack gap={1}>
          <HStack>
            <Heading size="lg">{account.name}</Heading>
            <Badge colorPalette={ACCOUNT_TYPE_LABELS[account.accountType] ? "brand" : "gray"}>
              {ACCOUNT_TYPE_LABELS[account.accountType] ?? account.accountType}
            </Badge>
          </HStack>
          <HStack gap={4} color="fg.muted" fontSize="sm">
            <Text>{account.accountNumber}</Text>
            <Text>{account.sortCode}</Text>
            <Text>Opened {formatDate(account.dateOpened)}</Text>
            {account.dateClosed && (
              <Text color="red.fg">Closed {formatDate(account.dateClosed)}</Text>
            )}
          </HStack>
        </Stack>
        <HStack gap={2} flexShrink={0}>
          <Button size="sm" variant="outline" onClick={() => setEditAccountOpen(true)}>
            Edit account
          </Button>
          <Button
            size="sm"
            colorPalette="red"
            variant="outline"
            onClick={() => setDeleteAccountOpen(true)}
          >
            Delete
          </Button>
        </HStack>
      </Flex>

      {/* Balance summary */}
      <Flex gap={6} wrap="wrap">
        {[
          { label: "Balance", value: balance },
          { label: "Deposits", value: account.balance?.totalDeposits ?? 0 },
          { label: "Withdrawals", value: account.balance?.totalWithdrawals ?? 0 },
          ...(account.accountType === "INVESTMENT_ISA"
            ? [{ label: "Variance", value: account.balance?.totalVariance ?? 0 }]
            : [{ label: "Interest", value: account.balance?.totalInterest ?? 0 }]),
        ].map(({ label, value }) => (
          <Box key={label}>
            <Text fontSize="xs" color="fg.muted" textTransform="uppercase" letterSpacing="wide">
              {label}
            </Text>
            <Text fontSize="xl" fontWeight="semibold">
              {formatGBP(value)}
            </Text>
          </Box>
        ))}
      </Flex>

      {/* Transaction table controls */}
      <Flex align="center" justify="space-between" wrap="wrap" gap={3}>
        <HStack gap={3}>
          <NativeSelect.Root size="sm" w="40">
            <NativeSelect.Field value={typeFilter} onChange={e => setTypeFilter(e.target.value)}>
              <option value="">All types</option>
              <option value="DEPOSIT">Deposit</option>
              <option value="WITHDRAWAL">Withdrawal</option>
              {account.accountType === "INVESTMENT_ISA" && (
                <option value="VARIANCE">Variance</option>
              )}
              {account.accountType !== "INVESTMENT_ISA" && (
                <option value="INTEREST">Interest</option>
              )}
            </NativeSelect.Field>
            <NativeSelect.Indicator />
          </NativeSelect.Root>
        </HStack>
        <Button size="sm" colorPalette="brand" onClick={() => setAddTxOpen(true)}>
          Add transaction
        </Button>
      </Flex>

      {/* Transaction table */}
      {transactions.length === 0 ? (
        <Text color="fg.muted" fontSize="sm">
          No transactions{typeFilter ? " matching the filter" : ""}.
        </Text>
      ) : (
        <Box overflowX="auto">
          <Table.Root size="sm">
            <Table.Header>
              <Table.Row>
                <Table.ColumnHeader
                  cursor="pointer"
                  onClick={() => toggleSort("date")}
                  userSelect="none"
                >
                  Date {sortKey === "date" ? (sortDir === "asc" ? "↑" : "↓") : ""}
                </Table.ColumnHeader>
                <Table.ColumnHeader>Type</Table.ColumnHeader>
                <Table.ColumnHeader>Description</Table.ColumnHeader>
                <Table.ColumnHeader
                  textAlign="right"
                  cursor="pointer"
                  onClick={() => toggleSort("amount")}
                  userSelect="none"
                >
                  Amount {sortKey === "amount" ? (sortDir === "asc" ? "↑" : "↓") : ""}
                </Table.ColumnHeader>
                <Table.ColumnHeader />
              </Table.Row>
            </Table.Header>
            <Table.Body>
              {transactions.map(tx => (
                <Table.Row key={tx.id}>
                  <Table.Cell color="fg.muted" whiteSpace="nowrap">
                    {formatDate(tx.date)}
                  </Table.Cell>
                  <Table.Cell>
                    <Badge size="sm" colorPalette={TRANSACTION_TYPE_COLORS[tx.type] ?? "gray"}>
                      {TRANSACTION_TYPE_LABELS[tx.type] ?? tx.type}
                    </Badge>
                  </Table.Cell>
                  <Table.Cell color="fg.muted">{tx.description ?? "—"}</Table.Cell>
                  <Table.Cell
                    textAlign="right"
                    fontWeight="medium"
                    color={
                      tx.type === "WITHDRAWAL" || (tx.type === "VARIANCE" && tx.amount < 0)
                        ? "red.fg"
                        : "green.fg"
                    }
                  >
                    {tx.type === "WITHDRAWAL" || (tx.type === "VARIANCE" && tx.amount < 0)
                      ? "−"
                      : "+"}
                    {formatGBP(Math.abs(tx.amount))}
                  </Table.Cell>
                  <Table.Cell>
                    <HStack gap={1} justify="flex-end">
                      <Button size="xs" variant="ghost" onClick={() => setEditTx(tx)}>
                        Edit
                      </Button>
                      <Button
                        size="xs"
                        variant="ghost"
                        colorPalette="red"
                        onClick={() => setDeleteTx(tx)}
                      >
                        Delete
                      </Button>
                    </HStack>
                  </Table.Cell>
                </Table.Row>
              ))}
            </Table.Body>
          </Table.Root>
        </Box>
      )}

      {/* Modals / Drawers */}
      <AccountForm
        open={editAccountOpen}
        account={account}
        onClose={() => setEditAccountOpen(false)}
        onSaved={() => {
          setEditAccountOpen(false);
          refetch();
        }}
      />

      <TransactionForm
        open={addTxOpen || !!editTx}
        accountId={accountId}
        accountType={account.accountType}
        transaction={editTx ?? undefined}
        onClose={() => {
          setAddTxOpen(false);
          setEditTx(null);
        }}
        onSaved={() => {
          setAddTxOpen(false);
          setEditTx(null);
          refetch();
        }}
      />

      <DeleteConfirmation
        open={!!deleteTx}
        title="Delete transaction"
        description="This will permanently remove the transaction and update the account balance."
        loading={deletingTx}
        onCancel={() => setDeleteTx(null)}
        onConfirm={handleDeleteTransaction}
      />

      <DeleteConfirmation
        open={deleteAccountOpen}
        title="Delete account"
        description="This will permanently delete the account and all its transactions. This cannot be undone."
        loading={deletingAccount}
        onCancel={() => setDeleteAccountOpen(false)}
        onConfirm={handleDeleteAccount}
      />
    </Stack>
  );
}
