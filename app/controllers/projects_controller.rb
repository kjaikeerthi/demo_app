class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    project = current_user.projects.create(params[:project])
    redirect_to root_path
  end

  def destroy
    project = current_user.projects.find(params[:id])
    project.delete
    redirect_to root_path
  end

  def show
    @project = current_user.projects.find(params[:id])
  end
end
