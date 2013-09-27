class AddOrdersTable < ActiveRecord::Migration
  def up
    create_table :orders do |t|
      t.references :user, :null => false
      t.references :ship_address, :null => false
      t.string :paypal_payment_id, :null => false

      t.integer :created_ts
    end
    execute "alter table orders add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :orders, :user_id
    add_index :orders, :created_ts

    create_table :order_products do |t|
      t.references :order, :null => false
      t.references :product, :null => false
      t.integer :time_tier, :null => false, :default => 0
      t.integer :random_tier, :null => false, :default => 0

      t.integer :created_ts
    end
    execute "alter table order_products add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :order_products, :order_id
    add_index :order_products, :product_id
    add_index :order_products, :time_tier
    add_index :order_products, :random_tier
    add_index :order_products, :created_ts
  end

  def down
    drop_table :orders
    drop_table :order_products
  end
end
