# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
puts 'Starting db:seed process'
if Merchant.count > 0
  puts 'Merchants have already been loaded'
else
  Rake::Task['import_csv:import_merchants'].invoke
end
#there is no clear indication why we have id's in the seed file. (normally we don't have) but these id's could help to
# avoid duplicate order creation if seed file run multiple time, as no information is given so i am following the
# tradational path and not recording these id's
if Order.count > 0
  puts 'Orders have already been loaded'
else
  Rake::Task['import_csv:import_orders'].invoke
end
if Disbursement.count > 0
  puts 'Disbursement have already been completed'
else
  puts '*********Starting DisbursementService for merchants with disbursement frequency Daily *********'
  DisbursementService.process_daily_history_disbursements
  puts '*********Starting DisbursementService for merchants with disbursement frequency Weekly *********'
  DisbursementService.process_weekly_history_disbursements
end
puts 'Finished db:seed process'
number_of_disbursements_2022 = Disbursement.where(disbursed_at: '2022-01-01'..'2022-12-31').count
number_of_disbursements_2023 = Disbursement.where(disbursed_at: '2023-01-01'..'2023-12-31').count
total_amount_disbursed_2022 = Disbursement.where(disbursed_at: '2022-01-01'..'2022-12-31').sum(:amount)
total_amount_disbursed_2023 = Disbursement.where(disbursed_at: '2023-01-01'..'2023-12-31').sum(:amount)

amount_of_order_fee_2022 = Disbursement.where(disbursed_at: '2022-01-01'..'2022-12-31').sum(:commission)
amount_of_order_fee_2023 = Disbursement.where(disbursed_at: '2023-01-01'..'2023-12-31').sum(:commission)



if MonthlyFeeRecord.count > 0
  puts 'MonthlyFeeRecord have already been generated'
else
  MonthlyFeeCalculatorService.process_historical_fees
end

number_of_monthly_fees_charged_2022 = MonthlyFeeRecord.where(record_month_date: '2022-01-01'..'2022-12-31').count
number_of_monthly_fees_charged_2023 = MonthlyFeeRecord.where(record_month_date: '2023-01-01'..'2023-12-31').count
amount_of_monthly_fees_charged_2022 = MonthlyFeeRecord.where(record_month_date: '2022-01-01'..'2022-12-31').sum(:fee)
amount_of_monthly_fees_charged_2023 = MonthlyFeeRecord.where(record_month_date: '2023-01-01'..'2023-12-31').sum(:fee)

puts "---------------------------"
puts "year 2022"
puts "Number of disbursements: #{number_of_disbursements_2022}"
puts "Amount disbursed to merchants: #{total_amount_disbursed_2022}"
puts "Amount of order fees #{amount_of_order_fee_2022}"
puts "Number of monthly fees charged (From minimum monthly fee): #{number_of_monthly_fees_charged_2022}"
puts "Amount of monthly fee charged (From minimum monthly fee): #{amount_of_monthly_fees_charged_2022}"
puts "---------------------------"
puts "year 2023"
puts "Number of disbursements: #{number_of_disbursements_2023}"
puts "Amount disbursed to merchants: #{total_amount_disbursed_2023}"
puts "Amount of order fees #{amount_of_order_fee_2023}"
puts "Number of monthly fees charged (From minimum monthly fee) #{number_of_monthly_fees_charged_2023}"
puts "Amount of monthly fee charged (From minimum monthly fee) #{amount_of_monthly_fees_charged_2023}"