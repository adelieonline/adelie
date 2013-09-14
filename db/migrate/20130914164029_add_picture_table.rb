class AddPictureTable < ActiveRecord::Migration
  def up
    create_table :pictures do |t|
      t.text :caption, :null => true
      t.references :product, :null => false

      t.integer :created_ts
    end
    execute "alter table pictures add updated_ts timestamp not null default current_timestamp on update current_timestamp;"
    add_attachment :pictures, :picture
  end
  def down
    drop_table :pictures
  end
end
