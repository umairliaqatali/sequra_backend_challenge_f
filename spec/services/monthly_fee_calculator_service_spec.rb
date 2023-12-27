require 'rails_helper'

RSpec.describe MonthlyFeeCalculatorService, type: :service do
  describe '.calculate_and_record_fee' do
    let(:merchant) { create(:merchant, live_on: 1.year.ago, minimum_monthly_fee: 100) }
    let(:start_date) { 1.month.ago.beginning_of_month }
    let(:end_date) { 1.month.ago.end_of_month - 1.days }

    context 'when total commission is less than minimum monthly fee' do
      before do
        create(:disbursement, merchant: merchant, disbursed_at: start_date + 1.day, commission: 50)
      end

      it 'creates a new monthly fee record' do
        expect { MonthlyFeeCalculatorService.calculate_and_record_fee(merchant, start_date, end_date) }
            .to change { MonthlyFeeRecord.count }.by(1)

        fee_record = MonthlyFeeRecord.last
        expect(fee_record.fee).to eq(50) # 100 minimum fee - 50 commission

        expected_date = (end_date + 1.day).to_date # Ensure this is a Date object
        expect(fee_record.record_month_date.to_date).to eq(expected_date)
      end
    end

    context 'when total commission meets or exceeds minimum monthly fee' do
      before do
        create(:disbursement, merchant: merchant, disbursed_at: start_date + 1.day, commission: 100)
      end

      it 'does not create a new monthly fee record' do
        expect { MonthlyFeeCalculatorService.calculate_and_record_fee(merchant, start_date, end_date) }
            .not_to change { MonthlyFeeRecord.count }
      end
    end

    context 'when a monthly fee record already exists for the period' do
      before do
        create(:monthly_fee_record, merchant: merchant, record_month_date: end_date + 1.day)
      end

      it 'does not create a duplicate monthly fee record' do
        expect { MonthlyFeeCalculatorService.calculate_and_record_fee(merchant, start_date, end_date) }
            .not_to change { MonthlyFeeRecord.count }
      end
    end
  end
end
