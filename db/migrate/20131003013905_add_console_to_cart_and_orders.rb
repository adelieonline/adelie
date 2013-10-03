class AddConsoleToCartAndOrders < ActiveRecord::Migration
  def up
    add_column :cart_items, :console_id, :int
    add_column :order_products, :console_id, :int
  end

  def down
    remove_column :cart_items, :console_id
    remove_column :order_products, :console_id
  end
end
