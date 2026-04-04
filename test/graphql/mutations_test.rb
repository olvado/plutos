require "test_helper"

class GraphQL::MutationsTest < ActiveSupport::TestCase
  setup do
    @user = create(:user)
    @other = create(:user)
    @context = { current_user: @user }
  end

  # createAccount

  test "createAccount creates an account for the current user" do
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        createAccount(input: {
          name: "My ISA"
          accountType: cash_isa
          accountNumber: "11223344"
          sortCode: "12-34-56"
          dateOpened: "2024-01-01T00:00:00Z"
        }) {
          account { id name accountType }
          errors
        }
      }
    GQL
    assert_nil result["errors"]
    assert_equal "My ISA", result.dig("data", "createAccount", "account", "name")
    assert_equal "cash_isa", result.dig("data", "createAccount", "account", "accountType")
    assert_equal @user.id, Account.last.user_id
  end

  test "createAccount returns errors with invalid data" do
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        createAccount(input: {
          name: ""
          accountType: savings
          accountNumber: "bad"
          sortCode: "bad"
          dateOpened: "2024-01-01T00:00:00Z"
        }) {
          account { id }
          errors
        }
      }
    GQL
    assert_nil result["errors"]
    assert result.dig("data", "createAccount", "errors").any?
    assert_nil result.dig("data", "createAccount", "account")
  end

  # updateAccount

  test "updateAccount updates own account" do
    account = create(:account, user: @user, name: "Old Name")
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        updateAccount(input: { id: #{account.id}, name: "New Name" }) {
          account { id name }
          errors
        }
      }
    GQL
    assert_nil result["errors"]
    assert_equal "New Name", result.dig("data", "updateAccount", "account", "name")
  end

  test "updateAccount raises forbidden for another user's account" do
    other_account = create(:account, user: @other)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        updateAccount(input: { id: #{other_account.id}, name: "Hacked" }) {
          account { id }
          errors
        }
      }
    GQL
    assert result["errors"].any?
    assert_equal "FORBIDDEN", result.dig("errors", 0, "extensions", "code")
  end

  # deleteAccount

  test "deleteAccount destroys own account" do
    account = create(:account, user: @user)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation { deleteAccount(input: { id: #{account.id} }) { success errors } }
    GQL
    assert_nil result["errors"]
    assert result.dig("data", "deleteAccount", "success")
    assert_not Account.exists?(account.id)
  end

  test "deleteAccount raises forbidden for another user's account" do
    other_account = create(:account, user: @other)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation { deleteAccount(input: { id: #{other_account.id} }) { success errors } }
    GQL
    assert result["errors"].any?
  end

  # createTransaction

  test "createTransaction creates deposit on own account" do
    account = create(:account, :cash_isa, user: @user)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        createTransaction(input: {
          accountId: #{account.id}
          type: Deposit
          amount: 500.0
          date: "2024-03-01T00:00:00Z"
          description: "Monthly save"
        }) {
          transaction { id amount type }
          errors
        }
      }
    GQL
    assert_nil result["errors"]
    assert_equal 500.0, result.dig("data", "createTransaction", "transaction", "amount")
    assert_equal "Deposit", result.dig("data", "createTransaction", "transaction", "type")
  end

  test "createTransaction raises forbidden for another user's account" do
    other_account = create(:account, user: @other)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        createTransaction(input: {
          accountId: #{other_account.id}
          type: Deposit
          amount: 100.0
          date: "2024-01-01T00:00:00Z"
        }) { transaction { id } errors }
      }
    GQL
    assert result["errors"].any?
  end

  # updateTransaction

  test "updateTransaction updates own transaction" do
    account = create(:account, :cash_isa, user: @user)
    txn = create(:deposit, account: account, amount: 200)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        updateTransaction(input: { id: #{txn.id}, amount: 300.0 }) {
          transaction { id amount }
          errors
        }
      }
    GQL
    assert_nil result["errors"]
    assert_equal 300.0, result.dig("data", "updateTransaction", "transaction", "amount")
  end

  test "updateTransaction raises forbidden for another user's transaction" do
    other_account = create(:account, user: @other)
    other_txn = create(:deposit, account: other_account, amount: 100)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        updateTransaction(input: { id: #{other_txn.id}, amount: 999.0 }) {
          transaction { id }
          errors
        }
      }
    GQL
    assert result["errors"].any?
  end

  # deleteTransaction

  test "deleteTransaction destroys own transaction" do
    account = create(:account, :cash_isa, user: @user)
    txn = create(:deposit, account: account)
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation { deleteTransaction(input: { id: #{txn.id} }) { success errors } }
    GQL
    assert_nil result["errors"]
    assert result.dig("data", "deleteTransaction", "success")
    assert_not Transaction.exists?(txn.id)
  end

  # updateProfile

  test "updateProfile updates name and email" do
    result = PlutosSchema.execute(<<~GQL, context: @context)
      mutation {
        updateProfile(input: { name: "New Name", email: "new@example.com" }) {
          user { name email }
          errors
        }
      }
    GQL
    assert_nil result["errors"]
    assert_equal "New Name", result.dig("data", "updateProfile", "user", "name")
  end
end
