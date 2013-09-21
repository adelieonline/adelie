class ProductController < ApplicationController
  def show
    product_id = params[:id].presence
    @product = Product.where(:id => product_id).first
    if not @product
      return redirect_to :controller => "index", :action => "index"
    end
  end
end
