class AddIconUrlsToConsoles < ActiveRecord::Migration
  def up
    add_column :consoles, :icon_url, :string
  end

  def down
    remove_column :consoles, :icon_url
  end
end
