class ProjectsController < ApplicationController
  before_filter :authenticate_user!
  
  def create
    project = current_user.projects.create(params[:project])
    project.settings.create({imap: "imap.gmail.com", name: "Google Mail", port: 993 })
    project.settings.create({imap: "imap.mail.yahoo.com", name: "Yahoo Mail", port: 993 })
    project.save
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
