class OrderShippingType < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :order_id,
                  :shipping_type_id
end
