# frozen_string_literal: true

module Sources
  class AccountBalanceSource < GraphQL::Dataloader::Source
    def fetch(account_ids)
      balances = AccountBalance.where(account_id: account_ids).index_by(&:account_id)
      account_ids.map { |id| balances[id] }
    end
  end
end
