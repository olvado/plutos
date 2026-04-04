class Deposit < Transaction
  validates :amount, numericality: { greater_than: 0 }
end
