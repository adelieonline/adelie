class AddOrderRefundTable < ActiveRecord::Migration
  def up
    create_table :order_refunds do |t|
     t.references :order, :null => false
     t.references :product, :null => false
     t.string :paypal_refund_id, :null => true
     t.decimal :refund_amount, :null => false

     t.integer :created_ts
    end
    execute "alter table order_refunds add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
  end

  def down
    drop_table :order_refunds
  end
end
