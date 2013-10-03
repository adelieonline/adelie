class CartItem < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :cart_id, :product_id, :quantity, :console_id, :created_ts, :updated_ts

  belongs_to :cart
end
