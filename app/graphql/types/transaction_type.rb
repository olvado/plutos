# frozen_string_literal: true

module Types
  class TransactionType < Types::BaseObject
    field :id, Integer, null: false
    field :type, Types::TransactionTypeEnum, null: false
    field :description, String, null: true
    field :amount, Float, null: false
    field :date, GraphQL::Types::ISO8601DateTime, null: false
    field :account_id, Integer, null: false
  end
end
