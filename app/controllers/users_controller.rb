class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.paginate(page: params[:page], per_page: Settings.defaults.per_page)
  end

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      remember(@user)
      flash[:success] = 'Welcome to the Sample App!'
      redirect_to @user
    else
      flash[:error] = 'There was an error creating your account. Please try again.'
      render 'new'
    end
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def correct_user
    redirect_to(root_url) unless @user == current_user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'Profile updated'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'User deleted' and redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'User not found.'
    redirect_to users_path
  end
end
