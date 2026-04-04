require "test_helper"

class AccountPolicyTest < ActiveSupport::TestCase
  setup do
    @owner = create(:user)
    @other = create(:user)
    @account = create(:account, user: @owner)
  end

  test "owner can show their account" do
    assert AccountPolicy.new(@owner, @account).show?
  end

  test "other user cannot show the account" do
    assert_not AccountPolicy.new(@other, @account).show?
  end

  test "owner can update their account" do
    assert AccountPolicy.new(@owner, @account).update?
  end

  test "other user cannot update the account" do
    assert_not AccountPolicy.new(@other, @account).update?
  end

  test "owner can destroy their account" do
    assert AccountPolicy.new(@owner, @account).destroy?
  end

  test "other user cannot destroy the account" do
    assert_not AccountPolicy.new(@other, @account).destroy?
  end

  test "any authenticated user can create an account" do
    assert AccountPolicy.new(@other, Account.new).create?
  end

  test "scope resolves only owner accounts" do
    other_account = create(:account, user: @other)
    scope = AccountPolicy::Scope.new(@owner, Account.all).resolve
    assert_includes scope, @account
    assert_not_includes scope, other_account
  end
end
