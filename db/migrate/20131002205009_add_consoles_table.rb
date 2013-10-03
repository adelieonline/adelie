class AddConsolesTable < ActiveRecord::Migration
  def up
    create_table :consoles do |t|
      t.string :name
    end
    create_table :product_consoles do |t|
      t.references :product, :null => false
      t.references :console, :null => false
    end
  end

  def down
    drop_table :consoles
    drop_table :product_consoles
  end
end
