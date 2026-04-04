# frozen_string_literal: true

module Types
  class AccountMonthlySummaryType < Types::BaseObject
    field :account_id, Integer, null: false
    field :month, GraphQL::Types::ISO8601DateTime, null: false
    field :deposits, Float, null: false
    field :withdrawals, Float, null: false
    field :variance, Float, null: false
    field :interest, Float, null: false
    field :net_change, Float, null: false
  end
end
