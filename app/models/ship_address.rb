class ShipAddress < ActiveRecord::Base
  include Concerns::ReportingRecord

  attr_accessible :user_id,
                  :name,
                  :address_one,
                  :address_two,
                  :city,
                  :state,
                  :country,
                  :created_ts,
                  :updated_ts

  belongs_to :user
end
