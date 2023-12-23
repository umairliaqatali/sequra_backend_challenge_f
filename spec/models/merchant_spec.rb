require 'rails_helper'
RSpec.describe Merchant, type: :model do
  # Define a valid set of attributes
  let(:valid_attributes) do
    {
        reference: "SomeReference",
        email: "test@example.com",
        live_on: Date.today,
        disbursement_frequency: "weekly",
        minimum_monthly_fee: 10.00
    }
  end

  describe 'validations' do
    subject { described_class.new(valid_attributes) }

    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a reference' do
      subject.reference = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without an email' do
      subject.email = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid with a duplicate email' do
      described_class.create(valid_attributes)
      subject.email = valid_attributes[:email]
      expect(subject).not_to be_valid
    end

    it 'is not valid with an invalid email format' do
      subject.email = 'invalid_email'
      expect(subject).not_to be_valid
    end

    it 'is not valid without a live_on date' do
      subject.live_on = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a disbursement_frequency' do
      subject.disbursement_frequency = nil
      expect(subject).not_to be_valid
    end

    it 'is not valid without a minimum_monthly_fee' do
      subject.minimum_monthly_fee = nil
      expect(subject).not_to be_valid
    end
  end
end
