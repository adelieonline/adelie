class User < ActiveRecord::Base
  include Concerns::ReportingRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :active, :created_ts, :updated_ts, :email, :password

  has_many :orders
  has_many :order_products
  has_many :credits

  def cart_length
    count = 0
    cart = Cart.where(user_id: self.id, :checked_out => false).first
    if cart
      cart.cart_items.each do |item|
        count += item.quantity
      end
    end
    return count
  end
end
