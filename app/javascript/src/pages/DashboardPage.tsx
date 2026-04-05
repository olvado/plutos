import React from "react";
import {
  Badge,
  Box,
  Card,
  Flex,
  Heading,
  SimpleGrid,
  Spinner,
  Stack,
  Text,
} from "@chakra-ui/react";
import { Link as RouterLink } from "react-router-dom";
import { AreaChart, Area, ResponsiveContainer, Tooltip } from "recharts";
import {
  useGetAccountsQuery,
  useGetRecentTransactionsQuery,
  GetAccountsQuery,
} from "../../graphql/generated";

const ACCOUNT_TYPE_LABELS: Record<string, string> = {
  SAVINGS: "Savings",
  CASH_ISA: "Cash ISA",
  INVESTMENT_ISA: "Investment ISA",
  LIFETIME_ISA: "Lifetime ISA",
};

const ACCOUNT_TYPE_COLORS: Record<string, string> = {
  SAVINGS: "blue",
  CASH_ISA: "green",
  INVESTMENT_ISA: "purple",
  LIFETIME_ISA: "orange",
};

const TRANSACTION_TYPE_LABELS: Record<string, string> = {
  DEPOSIT: "Deposit",
  WITHDRAWAL: "Withdrawal",
  VARIANCE: "Variance",
  INTEREST: "Interest",
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

type Account = NonNullable<GetAccountsQuery["accounts"]>[number];

function AccountCard({ account }: { account: Account }) {
  const balance = account.balance?.balance ?? 0;
  const colorPalette = ACCOUNT_TYPE_COLORS[account.accountType] ?? "gray";
  const last3Months = account.monthlySummaries.slice(-3);

  return (
    <Card.Root
      as={RouterLink}
      to={`/accounts/${account.id}`}
      _hover={{ textDecoration: "none", boxShadow: "md" }}
      transition="box-shadow 0.15s"
    >
      <Card.Body gap={3}>
        <Flex justify="space-between" align="flex-start">
          <Stack gap={0} flex={1} minW={0}>
            <Text fontWeight="semibold" truncate>
              {account.name}
            </Text>
            <Text fontSize="xs" color="fg.muted">
              {account.accountNumber}
            </Text>
          </Stack>
          <Badge colorPalette={colorPalette} flexShrink={0} ml={2}>
            {ACCOUNT_TYPE_LABELS[account.accountType] ?? account.accountType}
          </Badge>
        </Flex>

        <Text fontSize="2xl" fontWeight="bold">
          {formatGBP(balance)}
        </Text>

        {last3Months.length > 0 && (
          <Box h="48px">
            <ResponsiveContainer width="100%" height="100%">
              <AreaChart data={last3Months} margin={{ top: 0, right: 0, bottom: 0, left: 0 }}>
                <defs>
                  <linearGradient id={`grad-${account.id}`} x1="0" y1="0" x2="0" y2="1">
                    <stop
                      offset="5%"
                      stopColor="var(--chakra-colors-brand-500)"
                      stopOpacity={0.3}
                    />
                    <stop offset="95%" stopColor="var(--chakra-colors-brand-500)" stopOpacity={0} />
                  </linearGradient>
                </defs>
                <Tooltip
                  formatter={(v: number) => [formatGBP(v), "Net change"]}
                  labelFormatter={l => l}
                />
                <Area
                  type="monotone"
                  dataKey="netChange"
                  stroke="var(--chakra-colors-brand-500)"
                  fill={`url(#grad-${account.id})`}
                  dot={false}
                  strokeWidth={2}
                />
              </AreaChart>
            </ResponsiveContainer>
          </Box>
        )}

        {account.dateClosed && (
          <Text fontSize="xs" color="red.fg">
            Closed {formatDate(account.dateClosed)}
          </Text>
        )}
      </Card.Body>
    </Card.Root>
  );
}

export default function DashboardPage() {
  const { data: accountsData, loading: accountsLoading } = useGetAccountsQuery();
  const { data: txData, loading: txLoading } = useGetRecentTransactionsQuery({
    variables: { limit: 10 },
  });

  const accounts = accountsData?.accounts ?? [];
  const recentTx = txData?.recentTransactions ?? [];

  return (
    <Stack gap={8}>
      <Heading size="lg">Dashboard</Heading>

      {/* Account cards */}
      {accountsLoading ? (
        <Flex justify="center" py={12}>
          <Spinner />
        </Flex>
      ) : accounts.length === 0 ? (
        <Box
          borderWidth="1px"
          borderStyle="dashed"
          rounded="lg"
          p={12}
          textAlign="center"
          color="fg.muted"
        >
          <Text mb={2}>No accounts yet.</Text>
          <Text fontSize="sm">Use the Accounts page to add your first account.</Text>
        </Box>
      ) : (
        <SimpleGrid columns={{ base: 1, sm: 2, lg: 3 }} gap={4}>
          {accounts.map(account => (
            <AccountCard key={account.id} account={account} />
          ))}
        </SimpleGrid>
      )}

      {/* Recent transactions */}
      <Stack gap={3}>
        <Heading size="md">Recent activity</Heading>
        {txLoading ? (
          <Spinner />
        ) : recentTx.length === 0 ? (
          <Text color="fg.muted" fontSize="sm">
            No transactions yet.
          </Text>
        ) : (
          <Stack gap={0} borderWidth="1px" rounded="lg" overflow="hidden">
            {recentTx.map((tx, i) => (
              <Flex
                key={tx.id}
                px={4}
                py={3}
                align="center"
                justify="space-between"
                borderTopWidth={i > 0 ? "1px" : 0}
                _hover={{ bg: "bg.subtle" }}
              >
                <Stack gap={0}>
                  <Text fontSize="sm" fontWeight="medium">
                    {tx.description || TRANSACTION_TYPE_LABELS[tx.type] || tx.type}
                  </Text>
                  <Text fontSize="xs" color="fg.muted">
                    {formatDate(tx.date)}
                  </Text>
                </Stack>
                <Text
                  fontWeight="semibold"
                  color={
                    tx.type === "WITHDRAWAL" || (tx.type === "VARIANCE" && tx.amount < 0)
                      ? "red.fg"
                      : "green.fg"
                  }
                >
                  {tx.type === "WITHDRAWAL" ? "−" : "+"}
                  {formatGBP(Math.abs(tx.amount))}
                </Text>
              </Flex>
            ))}
          </Stack>
        )}
      </Stack>
    </Stack>
  );
}
