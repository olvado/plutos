# frozen_string_literal: true

module Types
  class AccountTypeEnum < Types::BaseEnum
    value "savings", "Standard savings account"
    value "cash_isa", "Cash Individual Savings Account"
    value "investment_isa", "Stocks and shares ISA"
    value "lifetime_isa", "Lifetime ISA"
  end
end
