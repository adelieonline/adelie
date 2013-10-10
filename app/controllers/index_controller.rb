class IndexController < ApplicationController

  def index
    @current_products = Product.all
  end

  def howitworks
    @product = Product.first if Product.first
  end

end
