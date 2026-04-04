# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :me, Types::UserType, null: false,
      description: "Returns the currently authenticated user"

    field :accounts, [ Types::AccountType ], null: false,
      description: "Returns all accounts belonging to the current user"

    field :account, Types::AccountType, null: false,
      description: "Returns a single account by ID" do
      argument :id, Integer, required: true
    end

    field :transactions, [ Types::TransactionType ], null: false,
      description: "Returns transactions for an account, with optional filters" do
      argument :account_id, Integer, required: true
      argument :type, Types::TransactionTypeEnum, required: false
      argument :from, GraphQL::Types::ISO8601DateTime, required: false
      argument :to, GraphQL::Types::ISO8601DateTime, required: false
    end

    def me
      context[:current_user]
    end

    def accounts
      AccountPolicy::Scope.new(context[:current_user], Account).resolve
    end

    def account(id:)
      record = Account.find(id)
      authorize_with_pundit!(record, :show?)
      record
    end

    def transactions(account_id:, type: nil, from: nil, to: nil)
      account = Account.find(account_id)
      authorize_with_pundit!(account, :show?)

      scope = account.transactions
      scope = scope.where(type: type) if type.present?
      scope = scope.where("date >= ?", from) if from.present?
      scope = scope.where("date <= ?", to) if to.present?
      scope.order(date: :desc)
    end

    private

    def authorize_with_pundit!(record, action)
      policy = Pundit.policy!(context[:current_user], record)
      raise GraphQL::ExecutionError.new("Not authorized", extensions: { code: "FORBIDDEN" }) unless policy.public_send(action)
    end
  end
end
