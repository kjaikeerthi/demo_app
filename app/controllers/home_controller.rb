class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @services = current_user.services.all
  end

end
