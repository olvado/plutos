# frozen_string_literal: true

module Mutations
  class UpdateTransaction < BaseMutation
    argument :id, Integer, required: true
    argument :amount, Float, required: false
    argument :date, GraphQL::Types::ISO8601DateTime, required: false
    argument :description, String, required: false

    field :transaction, Types::TransactionType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, **attrs)
      transaction = Transaction.find(id)
      authorize!(transaction)

      if transaction.update(attrs.compact)
        { transaction: transaction, errors: [] }
      else
        { transaction: nil, errors: transaction.errors.full_messages }
      end
    end

    private

    def authorize!(record)
      raise GraphQL::ExecutionError.new("Not authorized", extensions: { code: "FORBIDDEN" }) unless record.account.user_id == context[:current_user].id
    end
  end
end
