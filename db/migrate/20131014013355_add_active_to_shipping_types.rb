class AddActiveToShippingTypes < ActiveRecord::Migration
  def up
    add_column :shipping_types, :active, :boolean
  end

  def down
    remove_column :shipping_types, :active
  end
end
