# frozen_string_literal: true

module Mutations
  class UpdateAccount < BaseMutation
    argument :id, Integer, required: true
    argument :name, String, required: false
    argument :date_closed, GraphQL::Types::ISO8601DateTime, required: false

    field :account, Types::AccountType, null: true
    field :errors, [ String ], null: false

    def resolve(id:, **attrs)
      account = Account.find(id)
      authorize!(account, :update?)

      if account.update(attrs.compact)
        { account: account, errors: [] }
      else
        { account: nil, errors: account.errors.full_messages }
      end
    end

    private

    def authorize!(record, action)
      policy = Pundit.policy!(context[:current_user], record)
      raise GraphQL::ExecutionError.new("Not authorized", extensions: { code: "FORBIDDEN" }) unless policy.public_send(action)
    end
  end
end
