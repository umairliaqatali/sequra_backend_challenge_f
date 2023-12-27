# frozen_string_literal: true
class Disbursement < ApplicationRecord
  belongs_to :merchant
  has_many :orders, dependent: :nullify

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :commission, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :reference, presence: true, uniqueness: true
  validates :disbursed_at, presence: true

  #  one merchant should have only one disbursement on a given date. we are marking each order disbursement day so
  # no we can track and avoid duplication using disbursed_at 
end