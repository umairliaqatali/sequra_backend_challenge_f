class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2
      t.datetime :disbursed_at, null: true
      t.references :disbursement, foreign_key: true, null: true
      t.timestamps
    end
  end
end