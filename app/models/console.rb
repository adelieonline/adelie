class Console < ActiveRecord::Base
  attr_accessible :name, :icon_url

  has_many :product_consoles, :dependent => :destroy
  has_many :products, :through => :product_consoles
end
