FactoryBot.define do
  factory :merchant do
    # Replace these with the actual attributes of your Merchant model
    reference { "UniqueRef123" }
    email { "merchant@example.com" }
    live_on { Date.today - 1.month }
    disbursement_frequency { "WEEKLY" }
    minimum_monthly_fee { 10.00 }
  end
end