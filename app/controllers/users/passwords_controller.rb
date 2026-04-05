module Users
  class PasswordsController < Devise::PasswordsController
    skip_before_action :verify_authenticity_token, only: [ :create ]
    respond_to :json

    def create
      self.resource = resource_class.send_reset_password_instructions(resource_params)
      if successfully_sent?(resource)
        render json: { message: "Reset instructions sent" }, status: :ok
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
