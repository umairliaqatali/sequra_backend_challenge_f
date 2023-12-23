# frozen_string_literal: true
class Merchant < ApplicationRecord
  validates :reference, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :live_on, presence: true
  validates :disbursement_frequency, presence: true
  validates :minimum_monthly_fee, presence: true
end
