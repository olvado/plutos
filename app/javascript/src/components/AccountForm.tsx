import React, { useState } from "react";
import { Button, Drawer, Field, Input, NativeSelect, Stack, Text } from "@chakra-ui/react";
import {
  useCreateAccountMutation,
  useUpdateAccountMutation,
  GetAccountQuery,
} from "../../graphql/generated";
import ErrorAlert from "./ErrorAlert";

type Account = GetAccountQuery["account"];

interface AccountFormProps {
  open: boolean;
  account?: Account;
  onClose: () => void;
  onSaved: () => void;
}

const ACCOUNT_TYPES = [
  { value: "SAVINGS", label: "Savings" },
  { value: "CASH_ISA", label: "Cash ISA" },
  { value: "INVESTMENT_ISA", label: "Investment ISA" },
  { value: "LIFETIME_ISA", label: "Lifetime ISA" },
];

function toDateInputValue(iso: string | null | undefined): string {
  if (!iso) return "";
  return iso.slice(0, 10);
}

// Mounted only when open — state initializes from props, no setState-in-effect needed.
function AccountFormInner({
  account,
  onClose,
  onSaved,
}: {
  account?: Account;
  onClose: () => void;
  onSaved: () => void;
}) {
  const isEdit = !!account;

  const [name, setName] = useState(account?.name ?? "");
  const [accountType, setAccountType] = useState(account?.accountType ?? "SAVINGS");
  const [accountNumber, setAccountNumber] = useState(account?.accountNumber ?? "");
  const [sortCode, setSortCode] = useState(account?.sortCode ?? "");
  const [dateOpened, setDateOpened] = useState(toDateInputValue(account?.dateOpened));
  const [dateClosed, setDateClosed] = useState(toDateInputValue(account?.dateClosed));
  const [error, setError] = useState("");

  const [createAccount, { loading: creating }] = useCreateAccountMutation();
  const [updateAccount, { loading: updating }] = useUpdateAccountMutation();
  const loading = creating || updating;

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setError("");
    try {
      if (isEdit) {
        const result = await updateAccount({
          variables: {
            input: {
              id: account.id,
              name,
              dateClosed: dateClosed ? new Date(dateClosed).toISOString() : null,
            },
          },
        });
        const errors = result.data?.updateAccount?.errors ?? [];
        if (errors.length > 0) {
          setError(errors.join(", "));
          return;
        }
      } else {
        const result = await createAccount({
          variables: {
            input: {
              name,
              accountType: accountType as Parameters<
                typeof createAccount
              >[0]["variables"]["input"]["accountType"],
              accountNumber,
              sortCode,
              dateOpened: new Date(dateOpened).toISOString(),
              dateClosed: dateClosed ? new Date(dateClosed).toISOString() : null,
            },
          },
        });
        const errors = result.data?.createAccount?.errors ?? [];
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
        <Drawer.Title>{isEdit ? "Edit account" : "Add account"}</Drawer.Title>
        <Drawer.CloseTrigger />
      </Drawer.Header>
      <Drawer.Body>
        <Stack gap={4}>
          <ErrorAlert error={error} />

          <Field.Root required>
            <Field.Label>Account name</Field.Label>
            <Input
              value={name}
              onChange={e => setName(e.target.value)}
              placeholder="e.g. Marcus Savings"
            />
          </Field.Root>

          {!isEdit && (
            <>
              <Field.Root required>
                <Field.Label>Account type</Field.Label>
                <NativeSelect.Root>
                  <NativeSelect.Field
                    value={accountType}
                    onChange={e => setAccountType(e.target.value)}
                  >
                    {ACCOUNT_TYPES.map(t => (
                      <option key={t.value} value={t.value}>
                        {t.label}
                      </option>
                    ))}
                  </NativeSelect.Field>
                  <NativeSelect.Indicator />
                </NativeSelect.Root>
              </Field.Root>

              <Field.Root required>
                <Field.Label>Account number</Field.Label>
                <Input
                  value={accountNumber}
                  onChange={e => setAccountNumber(e.target.value)}
                  placeholder="12345678"
                  maxLength={8}
                />
                <Field.HelperText>8 digits</Field.HelperText>
              </Field.Root>

              <Field.Root required>
                <Field.Label>Sort code</Field.Label>
                <Input
                  value={sortCode}
                  onChange={e => setSortCode(e.target.value)}
                  placeholder="12-34-56"
                />
              </Field.Root>

              <Field.Root required>
                <Field.Label>Date opened</Field.Label>
                <Input
                  type="date"
                  value={dateOpened}
                  onChange={e => setDateOpened(e.target.value)}
                />
              </Field.Root>
            </>
          )}

          <Field.Root>
            <Field.Label>
              Date closed{" "}
              <Text as="span" color="fg.muted" fontWeight="normal">
                (optional)
              </Text>
            </Field.Label>
            <Input type="date" value={dateClosed} onChange={e => setDateClosed(e.target.value)} />
          </Field.Root>
        </Stack>
      </Drawer.Body>
      <Drawer.Footer gap={2}>
        <Button variant="outline" onClick={onClose} disabled={loading}>
          Cancel
        </Button>
        <Button type="submit" colorPalette="brand" loading={loading}>
          {isEdit ? "Save changes" : "Add account"}
        </Button>
      </Drawer.Footer>
    </Drawer.Content>
  );
}

export default function AccountForm({ open, account, onClose, onSaved }: AccountFormProps) {
  return (
    <Drawer.Root open={open} onOpenChange={({ open: o }) => !o && onClose()} placement="end">
      <Drawer.Backdrop />
      <Drawer.Positioner>
        {open && <AccountFormInner account={account} onClose={onClose} onSaved={onSaved} />}
      </Drawer.Positioner>
    </Drawer.Root>
  );
}
