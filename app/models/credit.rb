class Credit < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :user_id,
                  :order_id,
                  :order_product_id,
                  :product_id,
                  :credit,
                  :credit_used,
                  :created_ts,
                  :updated_ts,
                  :paypal_refund_id

  belongs_to :order

end
