# frozen_string_literal: true
class Disbursement < ApplicationRecord
  belongs_to :merchant

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :commission, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :reference, presence: true, uniqueness: true
  validates :disbursed_at, presence: true
end