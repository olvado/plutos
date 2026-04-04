require "test_helper"

class WithdrawalTest < ActiveSupport::TestCase
  test "valid with positive amount" do
    assert build(:withdrawal).valid?
  end

  test "invalid with zero amount" do
    assert_not build(:withdrawal, amount: 0).valid?
  end

  test "invalid with negative amount" do
    assert_not build(:withdrawal, amount: -50).valid?
  end
end
