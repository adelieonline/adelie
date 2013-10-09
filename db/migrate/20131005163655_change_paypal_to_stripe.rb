class ChangePaypalToStripe < ActiveRecord::Migration
  def up
    remove_column :order_refunds, :paypal_refund_id
    rename_column :orders, :paypal_payment_id, :stripe_charge_id
    add_column :orders, :card_last_four, :int, :limit => 4
    add_column :orders, :card_type, :string
  end

  def down
    add_column :order_refunds, :paypal_refund_id, :string
    rename_column :orders, :stripe_charge_id, :paypal_payment_id
    remove_column :orders, :card_last_four
    remove_column :orders, :card_type
  end
end
