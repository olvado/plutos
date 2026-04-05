module Users
  class SessionsController < Devise::SessionsController
    skip_before_action :verify_authenticity_token, only: [ :create, :destroy ]
    respond_to :json

    def create
      super do |resource|
        if resource.persisted?
          response.set_header("X-CSRF-Token", form_authenticity_token)
          render json: { user: user_json(resource) }, status: :ok and return
        end
      end
    end

    def destroy
      super do
        render json: { message: "Signed out successfully." }, status: :ok and return
      end
    end

    private

    def respond_to_on_destroy
      render json: { message: "Signed out successfully." }, status: :ok
    end

    def user_json(user)
      { id: user.id, name: user.name, email: user.email }
    end
  end
end
