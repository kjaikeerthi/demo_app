class ServicesController < ApplicationController
  before_filter :authenticate_user!, :except => [:post]
  
  def create
    if params[:service][:provider].downcase == "twitter"
      redirect_to '/auth/twitter'
    end
  end

  def callback
    auth = request.env["omniauth.auth"]
    uid = auth["uid"]
    unless current_user.services.find_by_uid(uid)
      current_user.services.create(
        uid: uid,
        provider: auth["provider"],
        auth_token: auth["credentials"]["token"],
        auth_secret: auth["credentials"]["secret"]
        )
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
    services = Service.find(params[:service])
    services.each do |service|
      account = Twitter::Client.new(oauth_token: service.auth_token, oauth_token_secret: service.auth_secret)
      account.update(params[:message])
    end
    redirect_to root_path
  end
end
