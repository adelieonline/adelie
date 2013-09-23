class AddShippingAddressTable < ActiveRecord::Migration
  def up
    create_table :ship_addresses do |t|
      t.references :user, :null => false
      t.string :name, :null => false
      t.string :address_one, :null => false
      t.string :address_two, :null => true
      t.string :city, :null => false
      t.string :state, :null => false
      t.string :country, :null => false

      t.integer :created_ts
    end
    execute "alter table ship_addresses add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :ship_addresses, :user_id
  end

  def down
    drop_table :ship_addresses
  end
end
