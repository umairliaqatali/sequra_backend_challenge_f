class DisbursementCalculatorService
  def initialize(order)
    @order = order
  end

  def self.call(order)
    new(order).call
  end

  def call
    commission = calculate_commission.round(2)
    disbursement_amount = (@order.amount.round(2) - commission).round(2)
    { commission: commission, disbursement_amount: disbursement_amount }
  end

  private

  def calculate_commission
    case @order.amount
    when 0...50
      @order.amount * 0.01
    when 50...300
      @order.amount * 0.0095
    else
      @order.amount * 0.0085
    end
  end
end