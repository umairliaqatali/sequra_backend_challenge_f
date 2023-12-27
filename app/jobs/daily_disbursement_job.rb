require 'sidekiq-scheduler'
class DailyDisbursementJob < ApplicationJob
  queue_as :default


  def perform(*args)
    Merchant.where(disbursement_frequency: 'DAILY').find_each do |merchant|
      DisbursementService.process_disbursements_for_merchant_on_date(merchant, Date.today)
    end
  end
end