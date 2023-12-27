FactoryBot.define do
  factory :disbursement do
    association :merchant
    amount { 100.0 }
    commission { 10.0 }
    reference { "UniqueRef123" }
    disbursed_at { Date.today }
    # Add other necessary attributes
  end
end