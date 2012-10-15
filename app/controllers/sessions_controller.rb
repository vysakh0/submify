class SessionsController < ApplicationController

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      render 'new'

    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def new
  end

  def destroy
    sign_out
    redirect_to '/signin' 
  end

end
