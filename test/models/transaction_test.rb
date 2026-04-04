require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  test "invalid without amount" do
    assert_not build(:deposit, amount: nil).valid?
  end

  test "invalid without date" do
    assert_not build(:deposit, date: nil).valid?
  end

  test "invalid with non-numeric amount" do
    assert_not build(:deposit, amount: "abc").valid?
  end

  test "belongs to account" do
    account = create(:account)
    deposit = create(:deposit, account: account)
    assert_equal account, deposit.account
  end
end
