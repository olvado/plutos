require "test_helper"

class AccountMonthlySummaryTest < ActiveSupport::TestCase
  test "groups transactions by month" do
    account = create(:account, :cash_isa)
    create(:deposit, account: account, amount: 1000, date: "2024-01-15")
    create(:deposit, account: account, amount: 500,  date: "2024-02-10")
    create(:interest, account: account, amount: 20,  date: "2024-01-31")

    summaries = AccountMonthlySummary.for_account(account.id).ordered
    assert_equal 2, summaries.count

    jan = summaries.first
    assert_equal 1000, jan.deposits.to_i
    assert_equal 20,   jan.interest.to_i
    assert_equal 1020, jan.net_change.to_i

    feb = summaries.last
    assert_equal 500, feb.deposits.to_i
  end

  test "is readonly" do
    account = create(:account)
    create(:deposit, account: account, amount: 100, date: "2024-01-01")
    summary = AccountMonthlySummary.for_account(account.id).ordered.first!
    assert_raises(ActiveRecord::ReadOnlyRecord) { summary.save }
  end
end
