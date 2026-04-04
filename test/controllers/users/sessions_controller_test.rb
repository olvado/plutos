require "test_helper"

class Users::SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = create(:user)
  end

  test "signs in with valid credentials" do
    post user_session_url,
      params: { user: { email: @user.email, password: "password123" } },
      as: :json

    assert_response :success
    json = response.parsed_body
    assert_equal @user.email, json.dig("user", "email")
    assert_equal @user.name, json.dig("user", "name")
  end

  test "returns 401 with invalid credentials" do
    post user_session_url,
      params: { user: { email: @user.email, password: "wrong" } },
      as: :json

    assert_response :unauthorized
  end

  test "signs out successfully" do
    sign_in @user
    delete destroy_user_session_url, as: :json

    assert_response :success
    assert_includes response.parsed_body["message"], "Signed out"
  end
end
