require "test_helper"

class TransactionPolicyTest < ActiveSupport::TestCase
  setup do
    @owner = create(:user)
    @other = create(:user)
    @account = create(:account, user: @owner)
    @transaction = create(:deposit, account: @account)
  end

  test "owner can show their transaction" do
    assert TransactionPolicy.new(@owner, @transaction).show?
  end

  test "other user cannot show the transaction" do
    assert_not TransactionPolicy.new(@other, @transaction).show?
  end

  test "owner can update their transaction" do
    assert TransactionPolicy.new(@owner, @transaction).update?
  end

  test "other user cannot update the transaction" do
    assert_not TransactionPolicy.new(@other, @transaction).update?
  end

  test "owner can destroy their transaction" do
    assert TransactionPolicy.new(@owner, @transaction).destroy?
  end

  test "other user cannot destroy the transaction" do
    assert_not TransactionPolicy.new(@other, @transaction).destroy?
  end

  test "scope resolves only owner transactions" do
    other_account = create(:account, user: @other)
    other_transaction = create(:deposit, account: other_account)

    scope = TransactionPolicy::Scope.new(@owner, Transaction.all).resolve
    assert_includes scope, @transaction
    assert_not_includes scope, other_transaction
  end
end
