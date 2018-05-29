class UsersController < ApplicationController
  def show
    begin
      @user = User.find params[:id]
    rescue ActiveRecord::RecordNotFound
      flash[:danger] = t :user_not_found
      redirect_to root_path
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t :welcome
      redirect_to @user
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit :name, :email,
        :password, :password_confirmation
    end
end
