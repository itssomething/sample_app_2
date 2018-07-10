class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:edit, :show, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if user.save
      log_in user
      flash[:success] = t :welcome
      redirect_to user
    else
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if user.update_attributes user_params
      flash[:success] = t :profile_updated
      redirect_to user
    else
      render :edit
    end
  end

  def destroy
    user.destroy
    flash[:success] = t :user_deleted
    redirect_to users_url
  end

  private
    attr_reader :user

    def user_params
      params.require(:user).permit :name, :email,
        :password, :password_confirmation
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = t :pls_log_in
        redirect_to login_url
      end
    end

    def correct_user
      redirect_to root_url unless user.current_user? current_user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def find_user
      @user = User.find_by id: params[:id]

      return if user
      flash[:danger] = :user_not_found
      redirect_to root_url
    end
end
