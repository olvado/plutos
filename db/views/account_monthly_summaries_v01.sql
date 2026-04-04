SELECT
  accounts.id AS account_id,
  DATE_TRUNC('month', transactions.date) AS month,
  COALESCE(SUM(CASE WHEN transactions.type = 'Deposit'    THEN transactions.amount ELSE 0 END), 0) AS deposits,
  COALESCE(SUM(CASE WHEN transactions.type = 'Withdrawal' THEN transactions.amount ELSE 0 END), 0) AS withdrawals,
  COALESCE(SUM(CASE WHEN transactions.type = 'Variance'   THEN transactions.amount ELSE 0 END), 0) AS variance,
  COALESCE(SUM(CASE WHEN transactions.type = 'Interest'   THEN transactions.amount ELSE 0 END), 0) AS interest,
  SUM(
    CASE
      WHEN transactions.type = 'Deposit'    THEN  transactions.amount
      WHEN transactions.type = 'Withdrawal' THEN -transactions.amount
      WHEN transactions.type = 'Variance'   THEN  transactions.amount
      WHEN transactions.type = 'Interest'   THEN  transactions.amount
      ELSE 0
    END
  ) AS net_change
FROM accounts
JOIN transactions ON transactions.account_id = accounts.id
GROUP BY accounts.id, DATE_TRUNC('month', transactions.date)
ORDER BY accounts.id, month
