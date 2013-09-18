class AddCartAndCartItems < ActiveRecord::Migration
  def up
    create_table :carts do |t|
      t.references :user, :null => false
      t.boolean :checked_out, :null => false, :default => false

      t.integer :created_ts
    end
    execute "alter table carts add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :carts, :user_id
    add_index :carts, :updated_ts

    create_table :cart_items do |t|
      t.references :cart, :null => false
      t.references :product, :null => false
      t.integer :quantity, :null => false

      t.integer :created_ts
    end
    execute "alter table cart_items add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :cart_items, :product_id
    add_index :cart_items, :created_ts
    add_index :cart_items, :updated_ts
  end

  def down
    drop_table :carts
    drop_table :cart_items
  end
end
