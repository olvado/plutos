module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    def create
      super do |resource|
        if resource.persisted?
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
