require 'rails_helper'

RSpec.describe MonthlyFeeRecord, type: :model do
  let(:merchant) do
    Merchant.create!(
      reference: "UniqueRef123",
      email: "merchant@example.com",
      live_on: Date.today,
      disbursement_frequency: "weekly",
      minimum_monthly_fee: 10.00
    )
  end
  let(:valid_attributes) do
    {
      merchant: merchant,
      fee: 100.00,
      record_month_date: Date.today.beginning_of_month
    }
  end

  subject { described_class.new(valid_attributes) }

  describe 'associations' do
    it 'belongs to a merchant' do
      expect(subject).to respond_to(:merchant)
    end
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a merchant' do
      subject.merchant = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a fee' do
      subject.fee = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a negative fee' do
      subject.fee = -1.0
      expect(subject).not_to be_valid
    end

    it 'is not valid without a record month date' do
      subject.record_month_date = nil
      expect(subject).not_to be_valid
    end
  end

end
