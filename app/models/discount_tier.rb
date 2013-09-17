class DiscountTier < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :product_id, :discount, :percent, :tier_number, :created_ts, :updated_ts

  belongs_to :product
end
