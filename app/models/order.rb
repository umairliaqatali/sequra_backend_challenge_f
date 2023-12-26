# frozen_string_literal: true
class Order < ApplicationRecord
  belongs_to :merchant
  belongs_to :disbursement, optional: true

  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validate :created_at_after_merchant_live_on
  private

  def created_at_after_merchant_live_on
    return if created_at.blank? || merchant.blank? || merchant.live_on.blank?

    if self.created_at < merchant.live_on
      errors.add(:created_at, "must be greater than the merchant's live_on date")
    end
  end

end
# Comment out created_at_after_merchant_live_on if data integrity is assured during import. also update relevant rspec.