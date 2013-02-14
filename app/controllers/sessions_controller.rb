#
# Submify - Dashboard of web and web activity
# Copyright (C) 2013 Vysakh Sreenivasan <support@submify.com>
#
# This file is part of Submify.
#
# Submify is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# Submify is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with Submify.  If not, see <http://www.gnu.org/licenses/>.
#
class SessionsController < ApplicationController

  before_filter :not_signed_user, only: [:create, :new, :send_again ]

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.verify?
        sign_in user if params[:remember_me]
        session[:user_id] = user.id
        redirect_to root_url
      else
        flash[:notice] = "You have not confirmed your email. #{view_context.link_to('Send Again?', send_again_path(id: user.id), method: :post)}".html_safe

        redirect_to root_url 
      end
    else
      flash.now[:error] = "Invalid username/password"
      render 'new' 
    end
  end

  def new
  end
  def send_again

    @user = User.find(params[:id])
    @user.send_confirmation 
    redirect_to root_url, :notice => "Email sent to your email, please confirm to activate your account "
  end



  def fb
    auth = env["omniauth.auth"]
    if @user = User.find_by_uid(auth.uid)
      session[:user_id] = @user.id
      redirect_to root_url
    else
      @user = User.from_omniauth(env["omniauth.auth"])
      #render 'fb'
      if @user.save
        session[:user_id] = @user.id
        redirect_to root_url

      else
        render 'fb'
      end
    end
  end

  def show_signup
    @user = User.new
  end
  def show_signin
    @user = User.new
  end
  def destroy
    sign_out
    session[:user_id] = nil
    redirect_to root_path, :notice => "Logged out!"
  end
  def failure
    render text: 'Sorry could not connect to Facebook App'
  end
  private

  def not_signed_user
    redirect_to root_path if signed_in? 
  end
end