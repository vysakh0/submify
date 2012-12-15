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
   user = User.from_omniauth(env["omniauth.auth"])
    sign_in user
    redirect_back_or root_url
  end

  def destroy
    sign_out
    session[:user_id] = nil
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
      
