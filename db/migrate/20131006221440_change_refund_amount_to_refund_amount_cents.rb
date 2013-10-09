class ChangeRefundAmountToRefundAmountCents < ActiveRecord::Migration
  def up
    rename_column :order_refunds, :refund_amount, :refund_amount_cents
  end

  def down
    rename_column :order_refunds, :refund_amount_cents, :refund_amount
  end
end
