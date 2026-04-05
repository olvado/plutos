require "application_system_test_case"

class AuthTest < ApplicationSystemTestCase
  test "login page renders" do
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    assert_selector "input[type=email]"
    assert_selector "input[type=password]"
    assert_selector "button", text: "Sign in"
  end

  test "signup page renders" do
    visit "/signup"
    assert_selector "h2", text: "Create your account"
    assert_selector "button", text: "Create account"
  end

  test "forgot password page renders" do
    visit "/forgot-password"
    assert_selector "h2", text: "Reset your password"
    assert_selector "button", text: "Send reset link"
  end

  test "unauthenticated visit to dashboard redirects to login" do
    visit "/dashboard"
    assert_current_path "/login"
  end

  test "sign in with valid credentials" do
    user = create(:user)
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    assert_selector "h2", text: "Dashboard"
  end

  test "sign out" do
    user = create(:user)
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    click_button "Sign out"
    assert_current_path "/login"
  end

  test "forgot password sends reset instructions" do
    user = create(:user)
    visit "/forgot-password"
    assert_selector "h2", text: "Reset your password"
    fill_in "Email", with: user.email
    click_button "Send reset link"
    assert_selector "h2", text: "Check your email"
  end

  test "sign in with invalid credentials shows error" do
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: "wrong@example.com"
    fill_in "Password", with: "wrongpassword"
    click_button "Sign in"
    assert_text "Invalid"
  end
end
