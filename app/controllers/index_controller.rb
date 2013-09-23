class IndexController < ApplicationController

  def index
    @product = Product.first if Product.first
  end

end
