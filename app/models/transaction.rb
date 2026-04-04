class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: true
  validates :date, presence: true
  validates :type, presence: true

  after_commit :refresh_materialized_views

  private

  def refresh_materialized_views
    AccountBalance.refresh
    AccountMonthlySummary.refresh
  end
end
