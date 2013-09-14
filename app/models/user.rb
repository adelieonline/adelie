class User < ActiveRecord::Base
  include Concerns::ReportingRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attr_accessible :active, :created_ts, :updated_ts
end
