class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user, only: [:edit, :update]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user
      flash[:success] = 'Пользователь успешно создан'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Пользователь успешно обновлен'
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def signed_in_user
    redirect_to signin_url, notice: 'Пожалуйста, войдите на сайт' unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, notice: 'Вы не можете редактировать профили других пользователей.') unless current_user?(@user)
  end
end
