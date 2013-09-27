class OrderProduct < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :order_id,
                  :product_id,
                  :time_tier,
                  :random_tier,
                  :created_ts,
                  :updated_ts

  belongs_to :order
end
