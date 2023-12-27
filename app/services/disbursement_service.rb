class DisbursementService

  def self.process_daily_history_disbursements
    Merchant.where(disbursement_frequency: 'DAILY').find_each do |merchant|
      merchant.orders.order(:created_at).pluck(:created_at).uniq.each do |order_day_date|
        process_disbursements_for_merchant_on_date(merchant, order_day_date + 1.days)
      end
    end
  end

  def self.process_weekly_history_disbursements
    Merchant.where(disbursement_frequency: 'WEEKLY').find_each do |merchant|
      ((merchant.live_on + 7.days).to_date..Date.today).select { |date| date.wday == merchant.live_on.wday }.each do |weekly_order_day_date|
        process_disbursements_for_merchant_on_date(merchant, weekly_order_day_date)
      end
    end
  end

  def self.process_disbursements_for_merchant_on_date(merchant, date)
    orders = merchant.orders.undisbursed_within_range(disbursement_date_range(date, merchant.disbursement_frequency))
    if orders.any?
      total_amount = orders.sum(:amount)
      total_commission = orders.sum { |order| DisbursementCalculatorService.call(order).fetch(:commission) }
      disbursement_amount = total_amount - total_commission

      begin
        ActiveRecord::Base.transaction do
          unique_ref = "#{date.year}_#{generate_unique_reference}"
          disbursement = Disbursement.create!(
            merchant: merchant,
            amount: disbursement_amount,
            commission: total_commission,
            reference: unique_ref,
            disbursed_at: date
          )

          if disbursement.persisted?
            orders.update_all(disbursement_id: disbursement.id, disbursed_at: disbursement.disbursed_at)
          else
            raise ActiveRecord::Rollback, "Disbursement creation failed"
          end
        end
      rescue => e
        DISBURSEMENT_LOGGER.error "Transaction failed: #{e.message} for merchant: #{merchant.id} for date: #{date}"
      end
    end
  end


  private


  def self.disbursement_date_range(date, frequency)
    case frequency
      #date.yesterday.in_time_zone.beginning_of_day..date.yesterday.in_time_zone.end_of_day if it is required to use timzone
    when 'DAILY'
      date.yesterday.beginning_of_day..date.yesterday.end_of_day
    when 'WEEKLY'
      (date - 7.days).beginning_of_day..date.yesterday.end_of_day
    else
      raise "Unknown disbursement frequency: #{frequency}"
    end
  end

  def self.generate_unique_reference
    loop do
      random_ref = SecureRandom.alphanumeric(10) # Example: generates a 10-character long random string
      break random_ref unless Disbursement.exists?(reference: random_ref)
    end
  end

end

