class Picture < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :caption, :created_ts, :updated_ts, :picture, :product_id, :picture_file_name, :picture_content_type
  has_attached_file :picture,
                    :styles =>  { :medium => "750x500>", :thumb => "100x100>" }

  belongs_to :product
end
