class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: true
  validates :date, presence: true
  validates :type, presence: true
end
