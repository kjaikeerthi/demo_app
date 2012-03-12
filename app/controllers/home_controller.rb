class HomeController < ApplicationController
  before_filter :authenticate_user!

  def index
    @projects = current_user.projects.all
  end

end
