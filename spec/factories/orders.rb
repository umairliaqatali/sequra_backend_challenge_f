FactoryBot.define do
  factory :order do
    merchant
    amount { 100.00 }
    created_at { Date.today}
  end
end
