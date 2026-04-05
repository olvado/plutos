import React, { useState } from "react";
import { Button, Drawer, Field, Input, NativeSelect, Stack, Textarea } from "@chakra-ui/react";
import {
  useCreateTransactionMutation,
  useUpdateTransactionMutation,
  GetAccountQuery,
  TransactionTypeEnum,
  AccountTypeEnum,
} from "../../graphql/generated";
import ErrorAlert from "./ErrorAlert";

type Transaction = NonNullable<GetAccountQuery["account"]["transactions"]>[number];

interface TransactionFormProps {
  open: boolean;
  accountId: number;
  accountType: string;
  transaction?: Transaction;
  onClose: () => void;
  onSaved: () => void;
}

function availableTypes(accountType: string): { value: string; label: string }[] {
  const base = [
    { value: "DEPOSIT", label: "Deposit" },
    { value: "WITHDRAWAL", label: "Withdrawal" },
  ];
  if (accountType === AccountTypeEnum.InvestmentIsa) {
    base.push({ value: "VARIANCE", label: "Variance" });
  } else {
    base.push({ value: "INTEREST", label: "Interest" });
  }
  return base;
}

function toDateInputValue(iso: string): string {
  return iso.slice(0, 10);
}

// Mounted only when open — state initializes from props, no setState-in-effect needed.
function TransactionFormInner({
  accountId,
  accountType,
  transaction,
  onClose,
  onSaved,
}: {
  accountId: number;
  accountType: string;
  transaction?: Transaction;
  onClose: () => void;
  onSaved: () => void;
}) {
  const isEdit = !!transaction;
  const types = availableTypes(accountType);

  const [type, setType] = useState(transaction?.type ?? types[0].value);
  const [amount, setAmount] = useState(transaction ? String(Math.abs(transaction.amount)) : "");
  const [date, setDate] = useState(
    transaction ? toDateInputValue(transaction.date) : toDateInputValue(new Date().toISOString())
  );
  const [description, setDescription] = useState(transaction?.description ?? "");
  const [error, setError] = useState("");

  const [createTransaction, { loading: creating }] = useCreateTransactionMutation();
  const [updateTransaction, { loading: updating }] = useUpdateTransactionMutation();
  const loading = creating || updating;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    const parsedAmount = parseFloat(amount);
    if (isNaN(parsedAmount) || parsedAmount <= 0) {
      setError("Amount must be a positive number.");
      return;
    }
    try {
      if (isEdit) {
        const result = await updateTransaction({
          variables: {
            input: {
              id: transaction.id,
              type: type as TransactionTypeEnum,
              amount: parsedAmount,
              date: new Date(date).toISOString(),
              description: description || null,
            },
          },
        });
        const errors = result.data?.updateTransaction?.errors ?? [];
        if (errors.length > 0) {
          setError(errors.join(", "));
          return;
        }
      } else {
        const result = await createTransaction({
          variables: {
            input: {
              accountId,
              type: type as TransactionTypeEnum,
              amount: parsedAmount,
              date: new Date(date).toISOString(),
              description: description || null,
            },
          },
        });
        const errors = result.data?.createTransaction?.errors ?? [];
        if (errors.length > 0) {
          setError(errors.join(", "));
          return;
        }
      }
      onSaved();
    } catch {
      setError("Something went wrong. Please try again.");
    }
  }

  return (
    <Drawer.Content as="form" onSubmit={handleSubmit}>
      <Drawer.Header>
        <Drawer.Title>{isEdit ? "Edit transaction" : "Add transaction"}</Drawer.Title>
        <Drawer.CloseTrigger />
      </Drawer.Header>
      <Drawer.Body>
        <Stack gap={4}>
          <ErrorAlert error={error} />

          <Field.Root required>
            <Field.Label>Type</Field.Label>
            <NativeSelect.Root>
              <NativeSelect.Field value={type} onChange={e => setType(e.target.value)}>
                {types.map(t => (
                  <option key={t.value} value={t.value}>
                    {t.label}
                  </option>
                ))}
              </NativeSelect.Field>
              <NativeSelect.Indicator />
            </NativeSelect.Root>
          </Field.Root>

          <Field.Root required>
            <Field.Label>Amount (£)</Field.Label>
            <Input
              type="number"
              min="0.01"
              step="0.01"
              value={amount}
              onChange={e => setAmount(e.target.value)}
              placeholder="0.00"
            />
          </Field.Root>

          <Field.Root required>
            <Field.Label>Date</Field.Label>
            <Input type="date" value={date} onChange={e => setDate(e.target.value)} />
          </Field.Root>

          <Field.Root>
            <Field.Label>Description (optional)</Field.Label>
            <Textarea
              value={description}
              onChange={e => setDescription(e.target.value)}
              placeholder="e.g. Monthly savings transfer"
              rows={2}
            />
          </Field.Root>
        </Stack>
      </Drawer.Body>
      <Drawer.Footer gap={2}>
        <Button variant="outline" onClick={onClose} disabled={loading}>
          Cancel
        </Button>
        <Button type="submit" colorPalette="brand" loading={loading}>
          {isEdit ? "Save changes" : "Add transaction"}
        </Button>
      </Drawer.Footer>
    </Drawer.Content>
  );
}

export default function TransactionForm({
  open,
  accountId,
  accountType,
  transaction,
  onClose,
  onSaved,
}: TransactionFormProps) {
  return (
    <Drawer.Root open={open} onOpenChange={({ open: o }) => !o && onClose()} placement="end">
      <Drawer.Backdrop />
      <Drawer.Positioner>
        {open && (
          <TransactionFormInner
            accountId={accountId}
            accountType={accountType}
            transaction={transaction}
            onClose={onClose}
            onSaved={onSaved}
          />
        )}
      </Drawer.Positioner>
    </Drawer.Root>
  );
}
