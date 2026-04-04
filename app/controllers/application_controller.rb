class ApplicationController < ActionController::Base
  include Pundit::Authorization

  allow_browser versions: :modern

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    render json: { error: "You are not authorized to perform this action." }, status: :forbidden
  end
end
