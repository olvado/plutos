class AccountMonthlySummary < ApplicationRecord
  include MaterializedView

  self.primary_key = nil

  belongs_to :account

  scope :for_account, ->(account_id) { where(account_id: account_id) }
  scope :ordered, -> { order(:month) }
end
