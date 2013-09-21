class IndexController < ApplicationController

  def index
    @product = Product.first
  end

end
