class OrderRefund < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :order_id,
                  :product_id,
                  :refund_amount,
                  :refunded,
                  :created_ts,
                  :updated_ts
end
