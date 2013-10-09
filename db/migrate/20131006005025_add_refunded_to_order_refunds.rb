class AddRefundedToOrderRefunds < ActiveRecord::Migration
  def up
    add_column :order_refunds, :refunded, :boolean, :default => false
  end

  def down
    remove_column :order_refunds, :refunded
  end
end
