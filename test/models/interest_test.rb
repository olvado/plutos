require "test_helper"

class InterestTest < ActiveSupport::TestCase
  test "valid with positive amount on cash_isa" do
    assert build(:interest).valid?
  end

  test "invalid with zero amount" do
    assert_not build(:interest, amount: 0).valid?
  end

  test "invalid with negative amount" do
    assert_not build(:interest, amount: -10).valid?
  end

  test "invalid on investment_isa account" do
    account = build(:account, :investment_isa)
    interest = build(:interest, account: account)
    assert_not interest.valid?
    assert_includes interest.errors[:base], "Interest transactions are not valid for investment ISA accounts"
  end

  test "valid on savings account" do
    account = build(:account, :savings)
    assert build(:interest, account: account).valid?
  end

  test "valid on lifetime_isa account" do
    account = build(:account, :lifetime_isa)
    assert build(:interest, account: account).valid?
  end
end
