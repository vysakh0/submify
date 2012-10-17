class UsersController < ApplicationController

  before_filter :signed_in_user, only: [:edit, :update]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :not_signed_user, only: [:create, :new]

  def create
    @user = User.new(params[:user])
    if @user.save
     redirect_to @user 
    else
      render 'new'
    end
  end
  def show
    @user = User.find(params[:id])
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

  private
    
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in" 
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def not_signed_user
        redirect_to root_path if signed_in?
    end
end
