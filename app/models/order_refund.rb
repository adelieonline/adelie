class OrderRefund < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :order_id, :product_id, :paypal_refund_id, :refund_amount, :created_ts, :updated_ts
end
