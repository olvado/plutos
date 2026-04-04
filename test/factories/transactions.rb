FactoryBot.define do
  factory :transaction do
    association :account
    description { Faker::Lorem.sentence(word_count: 3) }
    amount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    date { Faker::Date.backward(days: 365) }

    factory :deposit, class: "Deposit" do
      type { "Deposit" }
      amount { Faker::Number.decimal(l_digits: 3, r_digits: 2).to_d.abs }
    end

    factory :withdrawal, class: "Withdrawal" do
      type { "Withdrawal" }
      amount { Faker::Number.decimal(l_digits: 2, r_digits: 2).to_d.abs }
    end

    factory :variance, class: "Variance" do
      type { "Variance" }
      association :account, factory: [ :account, :investment_isa ]
      amount { [ 1, -1 ].sample * Faker::Number.decimal(l_digits: 2, r_digits: 2).to_d.abs }
    end

    factory :interest, class: "Interest" do
      type { "Interest" }
      association :account, factory: [ :account, :cash_isa ]
      amount { Faker::Number.decimal(l_digits: 1, r_digits: 2).to_d.abs }
    end
  end
end
