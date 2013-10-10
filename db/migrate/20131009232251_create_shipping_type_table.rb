class CreateShippingTypeTable < ActiveRecord::Migration
  def up
    create_table :shipping_types do |t|
      t.string :name, :null => false
      t.decimal :price, :null => false
    end
    create_table :order_shipping_types do |t|
      t.references :shipping_type, :null => false
      t.references :order, :null => false

      t.integer :created_ts
    end
    execute "alter table order_shipping_types add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :order_shipping_types, :shipping_type_id
    add_index :order_shipping_types, :order_id
  end

  def down
    drop_table :shipping_types
    drop_table :order_shipping_types
  end
end
