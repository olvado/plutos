# frozen_string_literal: true

module Types
  class TransactionTypeEnum < Types::BaseEnum
    value "Deposit", "Money deposited into account"
    value "Withdrawal", "Money withdrawn from account"
    value "Variance", "Market value change (investment accounts only)"
    value "Interest", "Interest earned (non-investment accounts only)"
  end
end
