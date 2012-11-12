class SessionsController < ApplicationController

  
  before_filter :not_signed_user, only: [:create, :new]

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_back_or user

    else
      flash.now[:error] = "Invalid username/password"
      render 'new' 
    end
  end

  def new
  auth_hash = request.env['omniauth.auth']
  @authorization = Authorization.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
  if @authorization
    user = User.find_by_email(@authorization.user.email)  
    sign_in user
    redirect_back_or user
  else
    user = User.new :name => auth_hash["user_info"]["name"], :email => auth_hash["user_info"]["email"]
    user.authorizations.build :provider => auth_hash["provider"], :uid => auth_hash["uid"]
    user.save
    sign_in user
    redirect_back_or user
  end
  end

  def destroy
    sign_out
    redirect_to root_path 
  end
  def failure
    render text: 'Sorry could not connect to Facebook App'
  end
  private

    def not_signed_user
         redirect_to root_path if signed_in? 
    end
end
      
      
      
