# frozen_string_literal: true

module Mutations
  class CreateTransaction < BaseMutation
    argument :account_id, Integer, required: true
    argument :type, Types::TransactionTypeEnum, required: true
    argument :amount, Float, required: true
    argument :date, GraphQL::Types::ISO8601DateTime, required: true
    argument :description, String, required: false

    field :transaction, Types::TransactionType, null: true
    field :errors, [ String ], null: false

    ALLOWED_TYPES = %w[Deposit Withdrawal Variance Interest].freeze

    def resolve(account_id:, type:, amount:, date:, description: nil)
      account = Account.find(account_id)
      authorize_account!(account)

      raise GraphQL::ExecutionError, "Invalid transaction type" unless ALLOWED_TYPES.include?(type)

      transaction = type.constantize.new(
        account: account,
        amount: amount,
        date: date,
        description: description
      )

      if transaction.save
        { transaction: transaction, errors: [] }
      else
        { transaction: nil, errors: transaction.errors.full_messages }
      end
    end

    private

    def authorize_account!(account)
      raise GraphQL::ExecutionError.new("Not authorized", extensions: { code: "FORBIDDEN" }) unless account.user_id == context[:current_user].id
    end
  end
end
