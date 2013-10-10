class AddProductQuantityAndPlaceInLine < ActiveRecord::Migration
  def up
    add_column :products, :num_orders, :int, :default => 0
    add_column :order_products, :place_in_line, :int, :null => false
  end

  def down
    remove_column :products, :num_orders
    remove_column :order_products, :place_in_line
  end
end
