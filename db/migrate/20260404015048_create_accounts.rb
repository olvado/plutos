class CreateAccounts < ActiveRecord::Migration[8.1]
  def change
    create_table :accounts do |t|
      t.string :name, null: false
      t.column :account_type, :account_type, null: false, default: "cash_isa"
      t.string :account_number, null: false
      t.string :sort_code, null: false
      t.datetime :date_opened, null: false
      t.datetime :date_closed
      t.references :user, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :accounts, :name
    add_index :accounts, :account_type
    add_index :accounts, :account_number, unique: true
    add_index :accounts, :sort_code
    add_index :accounts, :date_opened
    add_index :accounts, :date_closed
  end
end
