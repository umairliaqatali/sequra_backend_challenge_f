class AddUniqueIndexToMonthlyFeeRecords < ActiveRecord::Migration[7.0]
  def change
    add_index :monthly_fee_records, [:merchant_id, :record_month_date], unique: true, name: 'index_unique_monthly_fee_records_on_merchant_and_date'
  end
end
