class Console < ActiveRecord::Base
  attr_accessible :name

  has_many :product_consoles, :dependent => :destroy
  has_many :products, :through => :product_consoles
end
