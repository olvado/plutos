# frozen_string_literal: true

module Types
  class AccountType < Types::BaseObject
    field :id, Integer, null: false
    field :name, String, null: false
    field :account_type, Types::AccountTypeEnum, null: false
    field :account_number, String, null: false
    field :sort_code, String, null: false
    field :date_opened, GraphQL::Types::ISO8601DateTime, null: false
    field :date_closed, GraphQL::Types::ISO8601DateTime, null: true
    field :transactions, [ Types::TransactionType ], null: false
    field :balance, Types::AccountBalanceType, null: true
    field :monthly_summaries, [ Types::AccountMonthlySummaryType ], null: false
  end
end
