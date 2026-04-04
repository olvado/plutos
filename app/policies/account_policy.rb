class AccountPolicy < ApplicationPolicy
  def show? = own?
  def create? = true
  def update? = own?
  def destroy? = own?

  class Scope < ApplicationPolicy::Scope
    def resolve
      scope.where(user: user)
    end
  end

  private

  def own?
    record.user_id == user.id
  end
end
