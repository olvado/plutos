class Variance < Transaction
  validates :amount, numericality: { other_than: 0 }
  validate :account_must_be_investment_isa

  private

  def account_must_be_investment_isa
    return unless account

    errors.add(:base, "Variance transactions are only valid for investment ISA accounts") unless account.investment_isa?
  end
end
