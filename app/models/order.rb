class Order < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :user_id,
                  :ship_address_id,
                  :stripe_charge_id,
                  :card_last_four,
                  :card_type,
                  :total_cents,
                  :created_ts,
                  :updated_ts

  has_many :order_products
  has_many :credits
end
