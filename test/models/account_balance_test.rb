require "test_helper"

class AccountBalanceTest < ActiveSupport::TestCase
  test "reflects deposits and withdrawals after refresh" do
    account = create(:account, :cash_isa)
    create(:deposit, account: account, amount: 1000)
    create(:deposit, account: account, amount: 500)
    create(:withdrawal, account: account, amount: 200)

    balance = AccountBalance.find_by(account_id: account.id)
    assert_equal 1500, balance.total_deposits.to_i
    assert_equal 200, balance.total_withdrawals.to_i
    assert_equal 1300, balance.balance.to_i
  end

  test "reflects interest for cash_isa" do
    account = create(:account, :cash_isa)
    create(:deposit, account: account, amount: 1000)
    create(:interest, account: account, amount: 25)

    balance = AccountBalance.find_by(account_id: account.id)
    assert_equal 25, balance.total_interest.to_i
    assert_equal 1025, balance.balance.to_i
  end

  test "reflects variance for investment_isa" do
    account = create(:account, :investment_isa)
    create(:deposit, account: account, amount: 5000)
    create(:variance, account: account, amount: -300)

    balance = AccountBalance.find_by(account_id: account.id)
    assert_equal(-300, balance.total_variance.to_i)
    assert_equal 4700, balance.balance.to_i
  end

  test "balance is zero for account with no transactions" do
    account = create(:account)
    AccountBalance.refresh
    balance = AccountBalance.find_by(account_id: account.id)
    assert_equal 0, balance.balance.to_i
  end

  test "is readonly" do
    account = create(:account)
    AccountBalance.refresh
    balance = AccountBalance.find_by!(account_id: account.id)
    assert_raises(ActiveRecord::ReadOnlyRecord) { balance.save }
  end
end
