require "test_helper"

class Users::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "registers a new user" do
    post user_registration_url,
      params: {
        user: {
          name: "Alice",
          email: "alice@example.com",
          password: "password123",
          password_confirmation: "password123"
        }
      },
      as: :json

    assert_response :created
    json = response.parsed_body
    assert_equal "alice@example.com", json.dig("user", "email")
    assert_equal "Alice", json.dig("user", "name")
  end

  test "returns errors with invalid params" do
    post user_registration_url,
      params: {
        user: {
          name: "",
          email: "not-an-email",
          password: "short",
          password_confirmation: "mismatch"
        }
      },
      as: :json

    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].any?
  end

  test "returns error when email already taken" do
    existing = create(:user)
    post user_registration_url,
      params: {
        user: {
          name: "Bob",
          email: existing.email,
          password: "password123",
          password_confirmation: "password123"
        }
      },
      as: :json

    assert_response :unprocessable_entity
    assert response.parsed_body["errors"].any?
  end
end
