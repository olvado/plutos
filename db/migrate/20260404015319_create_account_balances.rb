class CreateAccountBalances < ActiveRecord::Migration[8.1]
  def change
    create_view :account_balances, materialized: true
    add_index :account_balances, :account_id, unique: true
  end
end
