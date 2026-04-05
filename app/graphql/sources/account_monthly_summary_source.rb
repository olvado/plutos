# frozen_string_literal: true

module Sources
  class AccountMonthlySummarySource < GraphQL::Dataloader::Source
    def fetch(account_ids)
      summaries = AccountMonthlySummary
        .where(account_id: account_ids)
        .order(:month)
        .group_by(&:account_id)
      account_ids.map { |id| summaries[id] || [] }
    end
  end
end
