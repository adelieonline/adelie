class AddUserIdToOrderProducts < ActiveRecord::Migration
  def up
    add_column :order_products, :user_id, :int, :limit => 11
    add_index :order_products, :user_id
  end

  def down
    remove_column :order_products, :user_id
  end
end
