class User < ActiveRecord::Base
  include Concerns::ReportingRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :active, :created_ts, :updated_ts, :email, :password

  has_many :orders
  has_one :shipping_address

  def cart_length
    count = 0
    Cart.where(user_id: self.id).first.cart_items.each do |item|
      count += item.quantity
    end
    return count
  end
end
