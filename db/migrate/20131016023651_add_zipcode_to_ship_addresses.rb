class AddZipcodeToShipAddresses < ActiveRecord::Migration
  def up
    add_column :ship_addresses, :zipcode, :int
  end

  def down
    remove_column :ship_addresses, :zipcode
  end
end
