class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:post, :show]

  def create
    @project = current_user.projects.find(params[:project_id])
    session[:project_id] = @project.id if @project

    if params[:service][:provider].downcase == "twitter"
      redirect_to '/auth/twitter'
    elsif params[:service][:provider].downcase == "facebook"
      redirect_to '/auth/facebook'
    elsif params[:service][:provider].downcase == "linkedin"
      redirect_to '/auth/linkedin'
    elsif params[:service][:provider].downcase == "imap"
      @imaps = @project.settings.all
      render "add_imap"
    end
  end

  def authenticate_imap
    @project = current_user.projects.find(params[:project_id])
    @project.services.create(
      provider: 'imap',
      uid: params[:service][:username],
      username: params[:service][:username],
      password: params[:service][:password],
      setting_id: params[:setting_id]
      )
    redirect_to project_path(@project.id)
  end

  def callback
    auth = request.env["omniauth.auth"]
    uid = auth["uid"]
    project = current_user.projects.find(session[:project_id]) if session && session[:project_id]
    session[:project_id] = nil
    if Project
      unless project.services.find_by_uid(uid)
        if auth["provider"] == "twitter"
          project.services.create(
            uid: uid,
            provider: auth["provider"],
            auth_token: auth["credentials"]["token"],
            auth_secret: auth["credentials"]["secret"]
            )
        elsif auth["provider"] == "facebook"
          project.services.create(
            uid: uid,
            provider: auth["provider"],
            auth_token: auth["credentials"]["token"]
            )
        elsif auth["provider"] == "linkedin"
          project.services.create(
            uid: uid,
            provider: auth["provider"],
            auth_token: auth["credentials"]["token"],
            auth_secret: auth["credentials"]["secret"]
            )
        elsif auth["provider"] == "google"
          project.services.create(
            uid: uid,
            provider: auth["provider"],
            auth_token: auth["credentials"]["token"],
            auth_secret: auth["credentials"]["secret"]
            )
        end
      else
        flash[:notice] = "This #{params[:provider].capitalize} account already belongs to you."
      end
      redirect_to project_path(project.id)
    else
      redirect_to root_path
    end
  end

  def destroy
    project = current_user.projects.find(params[:project_id])
    if project
      service = project.services.find(params[:id])
      service.delete
      redirect_to project_path(project.id)
    else
      redirect_to root_path
    end
  end

  def post
    @user = User.find(params[:user_id])
    @project = @user.projects.find(params[:project_id])
    if @project
      services = Service.find(params[:service])
      services.each do |service|
        if service.provider == "twitter"
          account = Twitter::Client.new(oauth_token: service.auth_token, oauth_token_secret: service.auth_secret)
          account.update(params[:message])
        elsif service.provider == "facebook"
          @fb = MiniFB::OAuthSession.new(service.auth_token)
          @fb.post('me', :type => :feed, :params => {
              :message => params[:message]
            })
        elsif service.provider == "linkedin"
          @client = LinkedIn::Client.new
          @client.authorize_from_access(service.auth_token, service.auth_secret)
          @client.update_status(params[:message])
        end
      end
      sign_in(@user)
      redirect_to project_path(@project.id)
    else
      redirect_to root_path
    end
  end

  def show
    @project = current_user.projects.find(params[:project_id])
    @service = Service.find(params[:id])

    if @service
      if @service.provider.downcase == "twitter"
        @account = Twitter::Client.new(oauth_token: @service.auth_token, oauth_token_secret: @service.auth_secret)
        @feeds = @account.home_timeline
      elsif @service.provider.downcase == "facebook"
        @account = MiniFB::OAuthSession.new(@service.auth_token)
        @feeds = @account.me.feed
      elsif @service.provider.downcase == "linkedin"
        @client = LinkedIn::Client.new
        @client.authorize_from_access(@service.auth_token, @service.auth_secret)
        @feeds = @client.network_updates
      elsif @service.provider.downcase == "imap"
        begin
          require 'net/imap'
          require 'mail'
          @setting = @project.settings.find(@service.setting_id)
          @imap = Net::IMAP.new(@setting.imap, @setting.port, true)
          @imap.login(@service.username, @service.password)
          @imap.select('INBOX')
          render "mail"
        rescue
          render text: "Error occured please try again later"
        end
      end
    end
  end

  def add
    @project = current_user.projects.find(params[:project_id])
  end

  def remove_setting
    @project = current_user.projects.find(params[:project_id])
    setting = @project.settings.find(params[:setting_id])
    setting.delete if setting
    redirect_to project_path(@project.id)
  end

  def create_imap
    @project = current_user.projects.find(params[:project_id])
    @project.settings.create(params[:imap])
    redirect_to project_path(@project.id)
  end

  def auth_mail
    @project = current_user.projects.find(params[:project_id])
    @setting = @project.settings.find(params[:setting_id])
  end

  def mail
    @project = current_user.projects.find(params[:project_id])
    @setting = @project.settings.find(params[:setting_id])
    require 'net/imap'
    require 'mail'
    @imap = Net::IMAP.new(@setting.imap, @setting.port, true)
    @imap.login(params[:username], params[:password])
    @imap.select('INBOX')    
  end
end
