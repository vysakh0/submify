class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update, :destroy, :following, :index, :notifications]
  before_filter :correct_user, only: [:edit, :update, :following, :notifications]
#rails4 makes filter into action, so you should have before_action
  before_filter :admin_user, only: :destroy
  def hovercard
    @user = User.find(params[:id])
    render partial: 'hovercard'
  end
  def index
      @users = User.all.paginate(page: params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end

  def commented

    @user = User.find(params[:id])
    @comments = @user.commented.paginate(page: params[:page], per_page: params[:page] || 15)
    respond_to do |format|
      format.html {render 'show_commented'}
      format.js 
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
    @link_users = @user.link_users.page(params[:page]).per_page(10)
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
    respond_to do |format|
      format.html {render 'show_following'}
      format.js
    end
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    respond_to do |format|

      format.html {render 'show_follow'}
      format.js
    end
  end
  def notifications
    @notifications = @user.notifications.order("updated_at DESC").paginate(page: params[:page])
    @user.update_column(:notifications_count, @notifications.first.updated_at) if @notifications.any?
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
