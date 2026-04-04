FactoryBot.define do
  factory :account do
    association :user
    name { Faker::Bank.name }
    account_type { :cash_isa }
    sequence(:account_number) { |n| format("%08d", n) }
    sort_code { "#{rand(10..99)}-#{rand(10..99)}-#{rand(10..99)}" }
    date_opened { Faker::Date.backward(days: 365 * 3) }
    date_closed { nil }

    trait :savings do
      account_type { :savings }
    end

    trait :cash_isa do
      account_type { :cash_isa }
    end

    trait :investment_isa do
      account_type { :investment_isa }
    end

    trait :lifetime_isa do
      account_type { :lifetime_isa }
    end

    trait :closed do
      date_closed { Faker::Date.between(from: date_opened + 30.days, to: Time.current) }
    end
  end
end
