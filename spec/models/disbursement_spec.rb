require 'rails_helper'
RSpec.describe Disbursement, type: :model do
  # Assuming you have a merchant factory or a setup for creating a merchant
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
        amount: 100.00,
        commission: 5.00,
        reference: 'UniqueRef123',
        disbursed_at: Time.now
    }
  end

  subject { described_class.new(valid_attributes) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without an amount' do
      subject.amount = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a non-numeric amount' do
      subject.amount = 'abc'
      expect(subject).not_to be_valid
    end

    it 'is not valid with an amount less than or equal to 0' do
      subject.amount = 0
      expect(subject).not_to be_valid
    end

    it 'is not valid without a commission' do
      subject.commission = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a non-numeric commission' do
      subject.commission = 'xyz'
      expect(subject).not_to be_valid
    end

    it 'is not valid with a negative commission' do
      subject.commission = -1.0
      expect(subject).not_to be_valid
    end

    it 'is not valid without a reference' do
      subject.reference = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate reference' do
      described_class.create(valid_attributes)
      another_disbursement = described_class.new(valid_attributes)
      expect(another_disbursement).not_to be_valid
    end

    it 'is not valid without a disbursed_at date' do
      subject.disbursed_at = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a merchant' do
      expect(subject).to respond_to(:merchant)
      expect(subject.merchant).to eq(merchant)
    end
  end

end