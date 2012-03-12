class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:post, :show]

  def create
    if params[:service][:provider].downcase == "twitter"
      redirect_to '/auth/twitter'
    elsif params[:service][:provider].downcase == "facebook"
      redirect_to '/auth/facebook'
    end
  end

  def callback

    auth = request.env["omniauth.auth"]
    uid = auth["uid"]
    unless current_user.services.find_by_uid(uid)
      if auth["provider"] == "twitter"
        current_user.services.create(
          uid: uid,
          provider: auth["provider"],
          auth_token: auth["credentials"]["token"],
          auth_secret: auth["credentials"]["secret"]
          )
      elsif auth["provider"] == "facebook"
        current_user.services.create(
          uid: uid,
          provider: auth["provider"],
          auth_token: auth["credentials"]["token"]
          )
      end
    else
      flash[:notice] = "This #{params[:provider].capitalize} account already belongs to you."
    end
    redirect_to root_path
  end

  def destroy
    service = current_user.services.find(params[:id])
    service.delete
    redirect_to root_path
  end

  def post
    @user = User.find(params[:user_id])
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
      end
    end
    sign_in(@user)
    redirect_to root_path
  end

  def show
    @service = Service.find(params[:id])
    if @service
      if @service.provider.downcase == "twitter"
        @account = Twitter::Client.new(oauth_token: @service.auth_token, oauth_token_secret: @service.auth_secret)
        @feeds = @account.home_timeline
      elsif @service.provider.downcase == "facebook"
        @account = MiniFB::OAuthSession.new(@service.auth_token)
        @feeds = @account.get("me", :type => "statuses")
      end
    end
  end
end
