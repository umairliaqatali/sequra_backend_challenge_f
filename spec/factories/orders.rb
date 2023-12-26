FactoryBot.define do
  factory :order do
    merchant # This assumes you have a factory for Merchant
    amount { 100.00 }
    created_at { Date.today}
    # Add other necessary attributes and/or associations
  end
end