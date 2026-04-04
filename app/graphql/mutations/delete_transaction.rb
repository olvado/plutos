# frozen_string_literal: true

module Mutations
  class DeleteTransaction < BaseMutation
    argument :id, Integer, required: true

    field :success, Boolean, null: false
    field :errors, [ String ], null: false

    def resolve(id:)
      transaction = Transaction.find(id)
      authorize!(transaction)
      transaction.destroy!
      { success: true, errors: [] }
    rescue ActiveRecord::RecordNotDestroyed => e
      { success: false, errors: [ e.message ] }
    end

    private

    def authorize!(record)
      raise GraphQL::ExecutionError.new("Not authorized", extensions: { code: "FORBIDDEN" }) unless record.account.user_id == context[:current_user].id
    end
  end
end
