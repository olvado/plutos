class CreateAccountTypeEnum < ActiveRecord::Migration[8.1]
  def up
    execute <<~SQL
      CREATE TYPE account_type AS ENUM ('savings', 'cash_isa', 'investment_isa', 'lifetime_isa');
    SQL
  end

  def down
    execute "DROP TYPE account_type;"
  end
end
