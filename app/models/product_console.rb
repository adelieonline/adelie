class ProductConsole < ActiveRecord::Base
  attr_accessible :product_id, :console_id

  belongs_to :product
  belongs_to :console
end
