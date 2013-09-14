class AddDiscountTierTable < ActiveRecord::Migration
  def up
    create_table :discount_tiers do |t|
      t.references :product
      t.decimal :discount, :precision => 10, :scale => 2
      t.decimal :percent, :precision => 10, :scale => 2
      t.integer :tier_number, :null => false

      t.integer :created_ts
    end
    execute "alter table discount_tiers add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_index :discount_tiers, :tier_number
  end
  def down
    drop_table :discount_tiers
  end
end
