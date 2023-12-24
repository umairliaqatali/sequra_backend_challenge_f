class CreateDisbursements < ActiveRecord::Migration[7.0]
  def change
    create_table :disbursements do |t|
      t.references :merchant, null: false, foreign_key: true
      t.decimal :amount, precision: 10, scale: 2, null: false
      t.decimal :commission, precision: 10, scale: 2, null: false
      t.string :reference, null: false
      t.datetime :disbursed_at, null: false
      t.timestamps
    end
    add_index :disbursements, :reference, unique: true
  end
end