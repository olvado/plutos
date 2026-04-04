class RemoveDescriptionIndexFromTransactions < ActiveRecord::Migration[8.1]
  def change
    remove_index :transactions, :description
  end
end
