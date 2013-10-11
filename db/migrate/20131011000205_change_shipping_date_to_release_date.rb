class ChangeShippingDateToReleaseDate < ActiveRecord::Migration
  def up
    rename_column :products, :ship_date, :release_date
  end

  def down
    rename_column :products, :release_date, :ship_date
  end
end
