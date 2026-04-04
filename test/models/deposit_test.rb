require "test_helper"

class DepositTest < ActiveSupport::TestCase
  test "valid with positive amount" do
    assert build(:deposit).valid?
  end

  test "invalid with zero amount" do
    assert_not build(:deposit, amount: 0).valid?
  end

  test "invalid with negative amount" do
    assert_not build(:deposit, amount: -100).valid?
  end
end
