class Interest < Transaction
  validates :amount, numericality: { greater_than: 0 }
  validate :account_must_not_be_investment_isa

  private

  def account_must_not_be_investment_isa
    return unless account

    errors.add(:base, "Interest transactions are not valid for investment ISA accounts") if account.investment_isa?
  end
end
