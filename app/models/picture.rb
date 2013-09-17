class Picture < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :caption, :created_ts, :updated_ts, :picture, :product_id, :picture_file_name, :picture_content_type
  has_attached_file :picture,
                    :styles =>  { :medium => "300x300>", :thumb => "100x100>" },
                    :default_url => "/images/:style/missing.png",
                    :url => "/assets/images/:basename.:extension",
                    :path => ":rails_root/public/assets/images/:basename.:extension"

  belongs_to :product
end
