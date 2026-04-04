require "test_helper"

class AccountTest < ActiveSupport::TestCase
  test "valid with all required attributes" do
    assert build(:account).valid?
  end

  test "invalid without name" do
    assert_not build(:account, name: nil).valid?
  end

  test "invalid without account_type" do
    assert_not build(:account, account_type: nil).valid?
  end

  test "invalid without account_number" do
    assert_not build(:account, account_number: nil).valid?
  end

  test "invalid without sort_code" do
    assert_not build(:account, sort_code: nil).valid?
  end

  test "invalid without date_opened" do
    assert_not build(:account, date_opened: nil).valid?
  end

  test "invalid with malformed sort_code" do
    assert_not build(:account, sort_code: "123456").valid?
    assert_not build(:account, sort_code: "12-34-5").valid?
    assert build(:account, sort_code: "12-34-56").valid?
  end

  test "invalid with non-8-digit account_number" do
    assert_not build(:account, account_number: "1234").valid?
    assert_not build(:account, account_number: "123456789").valid?
    assert build(:account, account_number: "12345678").valid?
  end

  test "invalid with duplicate account_number" do
    create(:account, account_number: "11223344")
    assert_not build(:account, account_number: "11223344").valid?
  end

  test "invalid when date_closed is before date_opened" do
    account = build(:account, date_opened: 1.year.ago, date_closed: 2.years.ago)
    assert_not account.valid?
    assert_includes account.errors[:date_closed], "must be after date opened"
  end

  test "valid when date_closed is after date_opened" do
    assert build(:account, :closed).valid?
  end

  test "open scope excludes closed accounts" do
    open_account  = create(:account)
    closed_account = create(:account, :closed)
    assert_includes Account.open, open_account
    assert_not_includes Account.open, closed_account
  end

  test "closed scope excludes open accounts" do
    open_account  = create(:account)
    closed_account = create(:account, :closed)
    assert_includes Account.closed, closed_account
    assert_not_includes Account.closed, open_account
  end

  test "account_type enum includes all expected types" do
    %w[savings cash_isa investment_isa lifetime_isa].each do |type|
      assert build(:account, account_type: type).valid?, "Expected #{type} to be valid"
    end
  end

  test "belongs to user" do
    user = create(:user)
    account = create(:account, user: user)
    assert_equal user, account.user
  end

  test "destroys transactions when destroyed" do
    account = create(:account)
    create(:deposit, account: account)
    assert_difference "Transaction.count", -1 do
      account.destroy
    end
  end
end
