class AddCreditTable < ActiveRecord::Migration
  def up
    create_table :credits do |t|
      t.references :user, :null => false
      t.references :order, :null => false
      t.references :order_product, :null => false
      t.references :product, :null => false
      t.decimal :credit, :null => false
      t.decimal :credit_used, :null => false, :default => 0

      t.integer :created_ts
    end
    execute "alter table credits add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :credits, :user_id
    add_index :credits, :order_id
    add_index :credits, :order_product_id
    add_index :credits, :product_id
    add_index :credits, :created_ts
  end

  def down
    drop_table :credits
  end
end
