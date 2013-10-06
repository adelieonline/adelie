class OrderRefund < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :order_id,
                  :product_id,
                  :refund_amount_cents,
                  :refunded,
                  :created_ts,
                  :updated_ts
end
