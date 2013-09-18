class Cart < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :user_id, :checked_out, :created_ts, :updated_ts

  has_many :cart_items
end
