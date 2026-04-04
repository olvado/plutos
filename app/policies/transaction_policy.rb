class TransactionPolicy < ApplicationPolicy
  def show? = own?
  def create? = own?
  def update? = own?
  def destroy? = own?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.joins(:account).where(accounts: { user_id: user.id })
    end
  end

  private

  def own?
    record.account.user_id == user.id
  end
end
