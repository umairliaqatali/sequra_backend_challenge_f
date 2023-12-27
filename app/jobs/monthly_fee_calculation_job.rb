require 'sidekiq-scheduler'
class MonthlyFeeCalculationJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Merchant.find_each do |merchant|
      if merchant.live_on.day == Date.today.day
        start_date = Date.today.prev_month
        end_date = Date.yesterday
        MonthlyFeeCalculatorService.calculate_and_record_fee(merchant, start_date, end_date)
      end
    end
  end
end
