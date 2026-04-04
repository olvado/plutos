class AddMissingIndexesToAccountsAndTransactions < ActiveRecord::Migration[8.1]
  def change
    add_index :accounts, :name
    add_index :accounts, :account_type
    add_index :accounts, :account_number, unique: true
    add_index :accounts, :sort_code
    add_index :accounts, :date_opened
    add_index :accounts, :date_closed

    add_index :transactions, :type
    add_index :transactions, :date
    add_index :transactions, :amount
    add_index :transactions, :description
  end
end
