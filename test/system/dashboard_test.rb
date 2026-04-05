require "application_system_test_case"

class DashboardTest < ApplicationSystemTestCase
  test "dashboard shows account cards" do
    user = create(:user)
    account = create(:account, user: user, name: "My Savings")
    create(:deposit, account: account, amount: 500)

    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    assert_selector "h2", text: "Dashboard"
    assert_text "My Savings"
  end

  test "dashboard shows empty state when no accounts" do
    user = create(:user)
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    assert_selector "h2", text: "Dashboard"
    assert_text "No accounts yet"
  end

  test "add account from navbar" do
    user = create(:user)
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    assert_selector "h2", text: "Dashboard"
    click_button "Add account"
    assert_text "Add account"
    fill_in "Account name", with: "Test Account"
    fill_in "Account number", with: "12345678"
    fill_in "Sort code", with: "12-34-56"
    fill_in "Date opened", with: "2024-01-01"
    click_button "Add account"
    assert_text "Test Account"
  end

  test "navigating to account detail" do
    user = create(:user)
    account = create(:account, user: user, name: "ISA Account")
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    assert_selector "h2", text: "Dashboard"
    click_on "ISA Account"
    assert_text "ISA Account"
    assert_text account.account_number
  end

  test "add transaction from account detail" do
    user = create(:user)
    account = create(:account, user: user, name: "Savings")
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    assert_selector "h2", text: "Dashboard"
    click_on "Savings"
    assert_text "Savings"
    click_button "Add transaction"
    assert_text "Add transaction"
    fill_in "Amount (£)", with: "250.00"
    click_button "Add transaction"
    assert_text "250"
  end

  test "profile page shows current user details" do
    user = create(:user, name: "Alice Test")
    visit "/login"
    assert_selector "h2", text: "Sign in to Plutos"
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Sign in"
    assert_current_path "/dashboard"
    assert_selector "h2", text: "Dashboard"
    click_on "Profile"
    assert_text "Profile"
    assert_field "Name", with: "Alice Test"
  end
end
