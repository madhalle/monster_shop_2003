class ProfileController < ApplicationController
  def index
    render file: "/public/404" unless current_user
  end

  def show
    render file: "/public/404" unless current_user
    @user = User.find(session[:user_id]) if current_user
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def edit_password
    @user = User.find(session[:user_id])
  end
end
