class AddProductTable < ActiveRecord::Migration
  def up
    create_table :products do |t|
      t.string :name, :null => false
      t.decimal :price, :precision => 10, :scale => 2
      t.text :description, :null => false
      t.text :tag_line, :null => true
      t.datetime :start_time, :null => false
      t.datetime :end_time, :null => false
      t.date :ship_date, :null => false
      t.boolean :credited, :default => false

      t.integer :created_ts
    end
    execute "alter table products add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :products, :name
    add_index :products, :price
    add_index :products, :start_time
    add_index :products, :end_time
    add_index :products, :ship_date
  end

  def down
    drop_table :products
  end
end
