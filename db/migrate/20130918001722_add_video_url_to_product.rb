class AddVideoUrlToProduct < ActiveRecord::Migration
  def up
    add_column :products, :video_url, :string, :null => true
  end

  def down
    remove_column :products, :video_url
  end
end
