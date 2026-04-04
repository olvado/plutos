class CreateAccountMonthlySummaries < ActiveRecord::Migration[8.1]
  def change
    create_view :account_monthly_summaries, materialized: true
    add_index :account_monthly_summaries, [ :account_id, :month ], unique: true
  end
end
