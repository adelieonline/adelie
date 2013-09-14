class Picture < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :caption, :created_ts, :updated_ts, :picture
  has_attached_file :picture, :styles =>  { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  belongs_to :product
end
