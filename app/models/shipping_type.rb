class ShippingType < ActiveRecord::Base
  attr_accessible :name,
                  :price

  has_many :order_shipping_types
  has_many :orders, :through => :order_shipping_types
end
