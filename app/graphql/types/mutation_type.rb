# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_account, mutation: Mutations::CreateAccount
    field :update_account, mutation: Mutations::UpdateAccount
    field :delete_account, mutation: Mutations::DeleteAccount

    field :create_transaction, mutation: Mutations::CreateTransaction
    field :update_transaction, mutation: Mutations::UpdateTransaction
    field :delete_transaction, mutation: Mutations::DeleteTransaction

    field :update_profile, mutation: Mutations::UpdateProfile
  end
end
