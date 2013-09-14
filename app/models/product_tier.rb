class ProductTier < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :discount, :percent, :tier_number, :created_ts, :updated_ts

  belongs_to :product
end
