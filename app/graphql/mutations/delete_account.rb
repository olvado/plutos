# frozen_string_literal: true

module Mutations
  class DeleteAccount < BaseMutation
    argument :id, Integer, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve(id:)
      account = Account.find(id)
      authorize!(account, :destroy?)
      account.destroy!
      { success: true, errors: [] }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [ e.message ] }
    end

    private

    def authorize!(record, action)
      policy = Pundit.policy!(context[:current_user], record)
      raise GraphQL::ExecutionError.new("Not authorized", extensions: { code: "FORBIDDEN" }) unless policy.public_send(action)
    end
  end
end
