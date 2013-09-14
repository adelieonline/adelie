module Concerns::ReportingRecord
  extend ActiveSupport::Concern

  included do
    before_create :set_created_ts

  protected
    def set_created_ts
      self.created_ts = ::Time.now.to_i
    end
  end

  module ClassMethods
  end
end
