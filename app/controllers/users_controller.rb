class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :destroy, :following, :followers, :index]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :not_signed_user, only: [:create, :new]

  before_filter :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
    
  def search
    @users = User.search params[:q]

    render :action => "index"
  end

  def create
    @user = User.new(params[:user])
    if @user.save
     sign_in @user
     redirect_to @user 
    else
      render 'new'
    end
  end
  def show
    @user = User.find(params[:id])
    @links = @user.links.paginate(page: params[:page])
  end
  def new
    @user = User.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash.now[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def not_signed_user
        redirect_to root_path if signed_in?
    end
end
