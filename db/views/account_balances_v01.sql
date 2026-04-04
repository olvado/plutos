SELECT
  accounts.id AS account_id,
  COALESCE(SUM(CASE WHEN transactions.type = 'Deposit'    THEN transactions.amount ELSE 0 END), 0) AS total_deposits,
  COALESCE(SUM(CASE WHEN transactions.type = 'Withdrawal' THEN transactions.amount ELSE 0 END), 0) AS total_withdrawals,
  COALESCE(SUM(CASE WHEN transactions.type = 'Variance'   THEN transactions.amount ELSE 0 END), 0) AS total_variance,
  COALESCE(SUM(CASE WHEN transactions.type = 'Interest'   THEN transactions.amount ELSE 0 END), 0) AS total_interest,
  COALESCE(SUM(CASE WHEN transactions.type = 'Deposit'    THEN transactions.amount ELSE 0 END), 0)
    - COALESCE(SUM(CASE WHEN transactions.type = 'Withdrawal' THEN transactions.amount ELSE 0 END), 0)
    + COALESCE(SUM(CASE WHEN transactions.type = 'Variance'   THEN transactions.amount ELSE 0 END), 0)
    + COALESCE(SUM(CASE WHEN transactions.type = 'Interest'   THEN transactions.amount ELSE 0 END), 0) AS balance
FROM accounts
LEFT JOIN transactions ON transactions.account_id = accounts.id
GROUP BY accounts.id
