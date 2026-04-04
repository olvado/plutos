class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.string :type, null: false
      t.string :description
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.datetime :date, null: false
      t.references :account, null: false, foreign_key: true, index: true

      t.timestamps
    end

    add_index :transactions, :type
    add_index :transactions, :date
    add_index :transactions, :amount
    add_index :transactions, :description
  end
end
