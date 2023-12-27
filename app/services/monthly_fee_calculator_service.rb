class MonthlyFeeCalculatorService
  def self.process_historical_fees
    Merchant.find_each do |merchant|
      process_fees_for_merchant(merchant)
    end
  end

  #for activejob we must check if it is first disbursement of the month, if yes then we should also call calculate_and_record_fee after job completion.
  def self.calculate_and_record_fee(merchant, start_date, end_date)
    merchant_disbursements = merchant.disbursements.where(disbursed_at: start_date..end_date)
    if merchant_disbursements.count > 0
      total_commission = merchant_disbursements.sum(:commission)
      if total_commission < merchant.minimum_monthly_fee
        existing_record = MonthlyFeeRecord.find_by(merchant: merchant, record_month_date: start_date)
        if existing_record.nil?
          MonthlyFeeRecord.create!(
            merchant: merchant,
            fee: merchant.minimum_monthly_fee - total_commission,
            record_month_date: end_date + 1.days
          )
        end
      end
    end
  end

  private

  def self.process_fees_for_merchant(merchant)
    month_start_date = merchant.live_on
    end_date = Date.today
    #as orders are limited some pervious days record is not present so for those days commission will always be less than monthly fee
    while month_start_date <= end_date
      month_end_date = month_start_date.next_month - 1.day
      calculate_and_record_fee(merchant, month_start_date, month_end_date)
      month_start_date = month_start_date.next_month
    end
  end

end
