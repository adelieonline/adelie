class Order < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :user_id,
                  :ship_address_id,
                  :paypal_payment_id,
                  :subtotal,
                  :tax,
                  :created_ts,
                  :updated_ts

  has_many :order_products
  has_many :credits
end
