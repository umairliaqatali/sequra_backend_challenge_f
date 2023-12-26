require 'rails_helper'
RSpec.describe DisbursementCalculatorService do
  describe '#call' do
    context 'when order amount is strictly smaller than 50' do
      let(:order) { create(:order, amount: 49.99) }
      subject { described_class.call(order) }

      it 'calculates the correct commission and disbursement amount' do
        expect(subject[:commission]).to eq(0.50) # 1% of 49.99
        expect(subject[:disbursement_amount]).to eq(49.49) # 49.99 - 0.50
      end
    end

    context 'when order amount is between 50 and 300' do
      let(:order) { create(:order, amount: 200.00) }
      subject { described_class.call(order) }

      it 'calculates the correct commission and disbursement amount' do
        expect(subject[:commission]).to eq(1.90) # 0.95% of 200
        expect(subject[:disbursement_amount]).to eq(198.10) # 200 - 1.90
      end
    end

    context 'when order amount is 300 or more' do
      let(:order) { create(:order, amount: 300.00) }
      subject { described_class.call(order) }

      it 'calculates the correct commission and disbursement amount' do
        expect(subject[:commission]).to eq(2.55) # 0.85% of 300
        expect(subject[:disbursement_amount]).to eq(297.45) # 300 - 2.55
      end
    end
  end
end
