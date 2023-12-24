class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
end
