class IndexController < ApplicationController

  def index
    return render :json => "OK"
  end

end
