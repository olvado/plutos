require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "validates presence of name" do
    assert_not build(:user, name: nil).valid?
  end

  test "validates presence of email" do
    assert_not build(:user, email: nil).valid?
  end

  test "validates uniqueness of email" do
    existing = create(:user)
    duplicate = build(:user, email: existing.email)
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "has many accounts" do
    user = create(:user)
    create(:account, user: user)
    create(:account, user: user)
    assert_equal 2, user.accounts.count
  end

  test "destroys associated accounts when destroyed" do
    user = create(:user)
    create(:account, user: user)
    assert_difference "Account.count", -1 do
      user.destroy
    end
  end

  test "has many transactions through accounts" do
    user = create(:user)
    account = create(:account, user: user)
    create(:deposit, account: account)
    assert_equal 1, user.transactions.count
  end

  test "valid with all required attributes" do
    assert build(:user).valid?
  end
end
