require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:merchant) do
    Merchant.create!(
      reference: "UniqueRef123",
      email: "merchant@example.com",
      live_on: Date.today,
      disbursement_frequency: "weekly",
      minimum_monthly_fee: 10.00
    )
  end
  let(:disbursement) do
    Disbursement.create!(
      merchant: merchant,
      amount: 100.00,
      commission: 5.00,
      reference: 'UniqueRef123',
      disbursed_at: Time.now
    )
  end

  let(:valid_attributes) do
    {
        merchant: merchant,
        amount: 100.00,
        disbursement: disbursement
    }
  end

  subject { described_class.new(valid_attributes) }

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a merchant' do
      subject.merchant = nil
      expect(subject).not_to be_valid
    end

    it 'is valid without a disbursement' do
      subject.disbursement = nil
      expect(subject).to be_valid
    end

    it 'is not valid with a negative amount' do
      subject.amount = -1
      expect(subject).not_to be_valid
    end

    it 'is not valid without an amount' do
      subject.amount = nil
      expect(subject).not_to be_valid
    end
  end

  describe 'associations' do
    it 'belongs to a merchant' do
      order = Order.new(merchant: merchant, amount: 100.00)
      expect(order.merchant).to eq(merchant)
    end

    it 'optionally belongs to a disbursement' do
      order_with_disbursement = Order.new(merchant: merchant, amount: 100.00, disbursement: disbursement)
      order_without_disbursement = Order.new(merchant: merchant, amount: 100.00)

      expect(order_with_disbursement.disbursement).to eq(disbursement)
      expect(order_without_disbursement.disbursement).to be_nil
    end

    #using factory_bot for complex scenarios and improve readability
    context 'custom validations' do
      let(:merchant) { create(:merchant, live_on: Date.yesterday) }

      context 'when created_at is after merchant live_on date' do
        let(:order) { build(:order, merchant: merchant, created_at: Date.today) }

        it 'is valid' do
          expect(order).to be_valid
        end
      end

      context 'when created_at is before merchant live_on date' do
        let(:order) { build(:order, merchant: merchant, created_at: merchant.live_on - 1.day) }

        it 'is not valid' do
          order.valid?
          expect(order.errors[:created_at]).to include("must be greater than the merchant's live_on date")
        end
      end
    end

  end
end
