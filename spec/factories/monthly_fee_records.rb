FactoryBot.define do
  factory :monthly_fee_record do
    association :merchant
    fee { 100.0 }  # Example fee amount, adjust as needed
    record_month_date { Date.today.beginning_of_month }
  end
end