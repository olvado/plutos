# frozen_string_literal: true

module Mutations
  class CreateAccount < BaseMutation
    argument :name, String, required: true
    argument :account_type, Types::AccountTypeEnum, required: true
    argument :account_number, String, required: true
    argument :sort_code, String, required: true
    argument :date_opened, GraphQL::Types::ISO8601DateTime, required: true
    argument :date_closed, GraphQL::Types::ISO8601DateTime, required: false

    field :account, Types::AccountType, null: true
    field :errors, [ String ], null: false

    def resolve(name:, account_type:, account_number:, sort_code:, date_opened:, date_closed: nil)
      account = context[:current_user].accounts.build(
        name: name,
        account_type: account_type,
        account_number: account_number,
        sort_code: sort_code,
        date_opened: date_opened,
        date_closed: date_closed
      )

      if account.save
        { account: account, errors: [] }
      else
        { account: nil, errors: account.errors.full_messages }
      end
    end
  end
end
