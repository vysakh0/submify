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
   @user = User.from_omniauth(env["omniauth.auth"])
    if (@user.valid? and  @user.password.is_nil?) or !@user.valid?
      #render 'fb'
    else
    @user.save!
    session[:user_id] = @user.id
    redirect_back_or root_url
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
      
