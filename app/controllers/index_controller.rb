class IndexController < ApplicationController

  def index
    all_products = Product.find(:all, :order => 'start_time')
    @current_products = []
    @upcoming_products = []
    all_products.each do |product|
      if product.is_active?
        @current_products.append(product)
      elsif product.is_upcoming?
        @upcoming_products.append(product)
      end
    end
    if @upcoming_products.length == 0
      @upcoming_products = nil
    end
    if @current_products.length == 0
      @current_products = nil
    end
  end

  def howitworks
    @product = Product.first if Product.first
  end

end
