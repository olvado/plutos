require "test_helper"

class VarianceTest < ActiveSupport::TestCase
  test "valid with positive amount on investment_isa" do
    assert build(:variance, amount: 200).valid?
  end

  test "valid with negative amount on investment_isa" do
    assert build(:variance, amount: -200).valid?
  end

  test "invalid with zero amount" do
    assert_not build(:variance, amount: 0).valid?
  end

  test "invalid on cash_isa account" do
    account = build(:account, :cash_isa)
    variance = build(:variance, account: account)
    assert_not variance.valid?
    assert_includes variance.errors[:base], "Variance transactions are only valid for investment ISA accounts"
  end

  test "invalid on savings account" do
    account = build(:account, :savings)
    variance = build(:variance, account: account)
    assert_not variance.valid?
  end
end
