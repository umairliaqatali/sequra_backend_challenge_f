class CreateMerchants < ActiveRecord::Migration[7.0]
  def change
    create_table :merchants do |t|
      t.string :reference, null: false
      t.string :email, null: false, index: { unique: true }
      t.date :live_on, null: false
      t.string :disbursement_frequency, null: false
      t.decimal :minimum_monthly_fee, precision: 10, scale: 2, null: false, default: 0.0
      t.timestamps
    end
  end

  def down
    drop_table :merchants
  end
end
