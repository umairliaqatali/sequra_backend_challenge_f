RSpec.describe DisbursementService, type: :service do
  describe 'process_daily_history_disbursements' do
    it 'processes disbursements for merchants with daily frequency' do
      daily_merchant = create(:merchant, disbursement_frequency: 'DAILY', live_on: 1.month.ago)
      create_list(:order, 5, merchant: daily_merchant, created_at: 2.days.ago)

      expect { DisbursementService.process_daily_history_disbursements }
          .to change { Disbursement.count }.by(1)
    end
  end

  describe 'process_weekly_history_disbursements' do
    it 'processes disbursements for merchants with weekly frequency' do
      weekly_merchant = create(:merchant, disbursement_frequency: 'WEEKLY', live_on: 1.month.ago)
      create_list(:order, 5, merchant: weekly_merchant, created_at: 1.week.ago)

      expect { DisbursementService.process_weekly_history_disbursements }
          .to change { Disbursement.count }.by(1)
    end
  end

  describe 'process_disbursements_for_merchant_on_date' do
    it 'creates disbursement records correctly' do
      merchant = create(:merchant)
      create(:order, merchant: merchant, amount: 100, created_at: Date.yesterday)

      expect { DisbursementService.process_disbursements_for_merchant_on_date( merchant, Date.today) }
          .to change { Disbursement.count }.by(1)

      disbursement = Disbursement.last
      expect(disbursement.amount + disbursement.commission).to eq(100)
    end
  end

  describe '.generate_unique_reference' do
    it 'generates a unique reference' do
      reference1 = DisbursementService.send(:generate_unique_reference)
      reference2 = DisbursementService.send(:generate_unique_reference)

      expect(reference1).not_to eq(reference2)
    end
  end

end