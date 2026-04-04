class Account < ApplicationRecord
  SORT_CODE_FORMAT = /\A\d{2}-\d{2}-\d{2}\z/
  ACCOUNT_NUMBER_FORMAT = /\A\d{8}\z/

  belongs_to :user
  has_many :transactions, dependent: :destroy
  has_many :deposits, dependent: :destroy
  has_many :withdrawals, dependent: :destroy
  has_many :variances, dependent: :destroy
  has_many :interests, dependent: :destroy

  has_one :balance, class_name: "AccountBalance"
  has_many :monthly_summaries, class_name: "AccountMonthlySummary"

  enum :account_type, {
    savings: "savings",
    cash_isa: "cash_isa",
    investment_isa: "investment_isa",
    lifetime_isa: "lifetime_isa"
  }

  validates :name, presence: true
  validates :account_type, presence: true
  validates :account_number, presence: true,
                              format: { with: ACCOUNT_NUMBER_FORMAT, message: "must be 8 digits" },
                              uniqueness: true
  validates :sort_code, presence: true,
                         format: { with: SORT_CODE_FORMAT, message: "must be in format XX-XX-XX" }
  validates :date_opened, presence: true
  validate :date_closed_after_date_opened

  scope :open, -> { where(date_closed: nil) }
  scope :closed, -> { where.not(date_closed: nil) }

  private

  def date_closed_after_date_opened
    return unless date_closed.present? && date_opened.present?

    errors.add(:date_closed, "must be after date opened") if date_closed <= date_opened
  end
end
