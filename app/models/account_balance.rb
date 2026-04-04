class AccountBalance < ApplicationRecord
  include MaterializedView

  self.primary_key = :account_id

  belongs_to :account
end
