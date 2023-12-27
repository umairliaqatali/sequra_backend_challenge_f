require 'sidekiq-scheduler'
class WeeklyDisbursementJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Merchant.where(disbursement_frequency: 'WEEKLY').find_each do |merchant|
      if merchant.live_on.wday == Date.today.wday
        DisbursementService.process_disbursements_for_merchant_on_date(merchant, Date.today)
      end
    end
  end
end
