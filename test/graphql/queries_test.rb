require "test_helper"

class GraphQL::QueriesTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @other = create(:user)
    @account = create(:account, :cash_isa, user: @user)
    @deposit = create(:deposit, account: @account, amount: 1000, date: "2024-01-15")
    @context = { current_user: @user }
  end

  # me query

  test "me returns current user" do
    result = PlutosSchema.execute("{ me { id name email } }", context: @context)
    assert_nil result["errors"]
    assert_equal @user.id, result.dig("data", "me", "id")
    assert_equal @user.name, result.dig("data", "me", "name")
  end

  # accounts query

  test "accounts returns only current user accounts" do
    other_account = create(:account, user: @other)
    result = PlutosSchema.execute("{ accounts { id name } }", context: @context)
    assert_nil result["errors"]
    ids = result.dig("data", "accounts").map { |a| a["id"] }
    assert_includes ids, @account.id
    assert_not_includes ids, other_account.id
  end

  # account query

  test "account returns a single account" do
    result = PlutosSchema.execute("{ account(id: #{@account.id}) { id name accountType } }", context: @context)
    assert_nil result["errors"]
    assert_equal @account.id, result.dig("data", "account", "id")
    assert_equal "cash_isa", result.dig("data", "account", "accountType")
  end

  test "account raises forbidden for another user's account" do
    other_account = create(:account, user: @other)
    result = PlutosSchema.execute("{ account(id: #{other_account.id}) { id } }", context: @context)
    assert result["errors"].any?
    assert_equal "FORBIDDEN", result.dig("errors", 0, "extensions", "code")
  end

  # transactions query

  test "transactions returns account transactions" do
    result = PlutosSchema.execute(
      "{ transactions(accountId: #{@account.id}) { id amount } }",
      context: @context
    )
    assert_nil result["errors"]
    assert_equal 1, result.dig("data", "transactions").length
    assert_equal 1000.0, result.dig("data", "transactions", 0, "amount")
  end

  test "transactions can be filtered by type" do
    create(:interest, account: @account, amount: 25)
    result = PlutosSchema.execute(
      "{ transactions(accountId: #{@account.id}, type: Deposit) { id type } }",
      context: @context
    )
    assert_nil result["errors"]
    txns = result.dig("data", "transactions")
    assert txns.all? { |t| t["type"] == "Deposit" }
  end

  test "transactions raises forbidden for another user's account" do
    other_account = create(:account, user: @other)
    result = PlutosSchema.execute(
      "{ transactions(accountId: #{other_account.id}) { id } }",
      context: @context
    )
    assert result["errors"].any?
    assert_equal "FORBIDDEN", result.dig("errors", 0, "extensions", "code")
  end
end
