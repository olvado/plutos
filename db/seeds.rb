user = User.find_or_initialize_by(email: "olvado@gmail.com")
user.assign_attributes(
  name: "olvado",
  password: "rhubarb",
  password_confirmation: "rhubarb",
  confirmed_at: Time.current
)
user.save!

cash_isa = user.accounts.find_or_create_by!(account_number: "12345678") do |a|
  a.name         = "My Cash ISA"
  a.account_type = "cash_isa"
  a.sort_code    = "12-34-56"
  a.date_opened  = "2020-01-01"
end

[
  { type: "Deposit",    description: "Initial deposit",           amount: 10_000.00, date: "2020-01-01" },
  { type: "Interest",   description: "Monthly interest",          amount:     20.00, date: "2020-02-01" },
  { type: "Withdrawal", description: "Emergency fund withdrawal", amount:  2_000.00, date: "2020-03-01" }
].each do |attrs|
  next if cash_isa.transactions.where(type: attrs[:type], date: attrs[:date]).exists?
  cash_isa.transactions.create!(attrs)
end

investment_isa = user.accounts.find_or_create_by!(account_number: "87654321") do |a|
  a.name         = "My Investment ISA"
  a.account_type = "investment_isa"
  a.sort_code    = "12-34-56"
  a.date_opened  = "2021-01-01"
end

[
  { type: "Deposit",  description: "Initial deposit",              amount: 15_000.00, date: "2021-01-01" },
  { type: "Variance", description: "Market variance for January",  amount:   -500.00, date: "2021-02-01" },
  { type: "Variance", description: "Market variance for February", amount:    300.00, date: "2021-03-01" }
].each do |attrs|
  next if investment_isa.transactions.where(type: attrs[:type], date: attrs[:date]).exists?
  investment_isa.transactions.create!(attrs)
end

puts "Seeded: #{User.count} user(s), #{Account.count} account(s), #{Transaction.count} transaction(s)"
