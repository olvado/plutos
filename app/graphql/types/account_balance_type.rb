# frozen_string_literal: true

module Types
  class AccountBalanceType < Types::BaseObject
    field :account_id, Integer, null: false
    field :total_deposits, Float, null: false
    field :total_withdrawals, Float, null: false
    field :total_variance, Float, null: false
    field :total_interest, Float, null: false
    field :balance, Float, null: false
  end
end
