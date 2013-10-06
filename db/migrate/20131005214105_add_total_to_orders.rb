class AddTotalToOrders < ActiveRecord::Migration
  def up
    add_column :orders, :total_cents, :int
  end

  def down
    remove_column :orders, :total_cents
  end
end
