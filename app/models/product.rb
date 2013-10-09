class Product < ActiveRecord::Base
  include Concerns::ReportingRecord
  attr_accessible :name,
                    :price,
                    :description,
                    :tag_line,
                    :start_time,
                    :end_time,
                    :ship_date,
                    :credited,
                    :video_url,
                    :num_orders,
                    :created_ts,
                    :updated_ts

  has_many :pictures
  has_many :order_products
  has_many :discount_tiers
  has_many :credits
  has_many :product_consoles, :dependent => :destroy
  has_many :consoles, :through => :product_consoles

  def is_ready?
    return self.pictures.length > 0
  end

  def is_active?
    return self.start_time < Time.now.utc && self.end_time > Time.now.utc
  end

  def is_upcoming?
    return self.start_time > Time.now.utc
  end

  def is_past?
    return self.end_time < Time.now.utc
  end

end
