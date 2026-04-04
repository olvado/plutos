# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_04_04_020731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "account_type", ["savings", "cash_isa", "investment_isa", "lifetime_isa"]

  create_table "accounts", force: :cascade do |t|
    t.string "account_number"
    t.string "account_type"
    t.datetime "created_at", null: false
    t.datetime "date_closed"
    t.datetime "date_opened"
    t.string "name"
    t.string "sort_code"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["account_number"], name: "index_accounts_on_account_number", unique: true
    t.index ["account_type"], name: "index_accounts_on_account_type"
    t.index ["date_closed"], name: "index_accounts_on_date_closed"
    t.index ["date_opened"], name: "index_accounts_on_date_opened"
    t.index ["name"], name: "index_accounts_on_name"
    t.index ["sort_code"], name: "index_accounts_on_sort_code"
    t.index ["user_id"], name: "index_accounts_on_user_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "date"
    t.string "description"
    t.string "type"
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_transactions_on_account_id"
    t.index ["amount"], name: "index_transactions_on_amount"
    t.index ["date"], name: "index_transactions_on_date"
    t.index ["description"], name: "index_transactions_on_description"
    t.index ["type"], name: "index_transactions_on_type"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "confirmation_sent_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "email"
    t.string "encrypted_password", default: "", null: false
    t.integer "failed_attempts", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "last_sign_in_ip"
    t.datetime "locked_at"
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.string "unconfirmed_email"
    t.string "unlock_token"
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "accounts", "users"
  add_foreign_key "transactions", "accounts"

  create_view "account_balances", materialized: true, sql_definition: <<-SQL
      SELECT accounts.id AS account_id,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Deposit'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS total_deposits,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Withdrawal'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS total_withdrawals,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Variance'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS total_variance,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Interest'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS total_interest,
      (((COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Deposit'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) - COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Withdrawal'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric)) + COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Variance'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric)) + COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Interest'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric)) AS balance
     FROM (accounts
       LEFT JOIN transactions ON ((transactions.account_id = accounts.id)))
    GROUP BY accounts.id;
  SQL
  add_index "account_balances", ["account_id"], name: "index_account_balances_on_account_id", unique: true

  create_view "account_monthly_summaries", materialized: true, sql_definition: <<-SQL
      SELECT accounts.id AS account_id,
      date_trunc('month'::text, transactions.date) AS month,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Deposit'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS deposits,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Withdrawal'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS withdrawals,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Variance'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS variance,
      COALESCE(sum(
          CASE
              WHEN ((transactions.type)::text = 'Interest'::text) THEN transactions.amount
              ELSE (0)::numeric
          END), (0)::numeric) AS interest,
      sum(
          CASE
              WHEN ((transactions.type)::text = 'Deposit'::text) THEN transactions.amount
              WHEN ((transactions.type)::text = 'Withdrawal'::text) THEN (- transactions.amount)
              WHEN ((transactions.type)::text = 'Variance'::text) THEN transactions.amount
              WHEN ((transactions.type)::text = 'Interest'::text) THEN transactions.amount
              ELSE (0)::numeric
          END) AS net_change
     FROM (accounts
       JOIN transactions ON ((transactions.account_id = accounts.id)))
    GROUP BY accounts.id, (date_trunc('month'::text, transactions.date))
    ORDER BY accounts.id, (date_trunc('month'::text, transactions.date));
  SQL
  add_index "account_monthly_summaries", ["account_id", "month"], name: "index_account_monthly_summaries_on_account_id_and_month", unique: true

end
