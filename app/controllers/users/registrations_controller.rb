module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token, only: [ :create ]
    respond_to :json

    def create
      build_resource(sign_up_params)

      if resource.save
        render json: { user: user_json(resource) }, status: :created
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      super do |resource|
        if resource.errors.empty?
          render json: { user: user_json(resource) }, status: :ok and return
        end
      end
    end

    def destroy
      super do
        render json: { message: "Account deleted successfully." }, status: :ok and return
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :current_password)
    end

    def user_json(user)
      { id: user.id, name: user.name, email: user.email }
    end
  end
end
