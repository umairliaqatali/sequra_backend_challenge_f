class MonthlyFeeRecord < ApplicationRecord
  belongs_to :merchant

  validates :fee, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :record_month_date, presence: true, uniqueness: { scope: :merchant_id }
end
