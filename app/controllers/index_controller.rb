class IndexController < ApplicationController

  def index
    @current_product = Product.first if Product.first
  end

  def howitworks
    @product = Product.first if Product.first
  end

end
