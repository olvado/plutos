# frozen_string_literal: true

module Mutations
  class UpdateProfile < BaseMutation
    argument :name, String, required: false
    argument :email, String, required: false
    argument :password, String, required: false
    argument :password_confirmation, String, required: false
    argument :current_password, String, required: false

    field :user, Types::UserType, null: true
    field :errors, [ String ], null: false

    def resolve(**attrs)
      user = context[:current_user]
      attrs.compact!

      if attrs.key?(:password)
        unless user.valid_password?(attrs.delete(:current_password))
          return { user: nil, errors: [ "Current password is incorrect" ] }
        end
      end

      if user.update(attrs)
        { user: user, errors: [] }
      else
        { user: nil, errors: user.errors.full_messages }
      end
    end
  end
end
