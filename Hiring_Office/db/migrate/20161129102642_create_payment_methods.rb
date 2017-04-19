class CreatePaymentMethods < ActiveRecord::Migration[5.0]
  def change
    create_table :payment_methods do |t|
      t.integer :payment_type
      t.text :email
      t.boolean :is_chosen, default: true
      t.references :venue, foreign_key: true
      t.references :paypal

      t.timestamps
    end
  end
end
