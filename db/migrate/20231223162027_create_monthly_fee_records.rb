class CreateMonthlyFeeRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :monthly_fee_records do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :fee, precision: 10, scale: 2, null: false
      t.date :record_month_date,null: false
      t.timestamps
    end
  end
end
