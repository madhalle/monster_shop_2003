class ProfileController < ApplicationController
  def index
    render file: "/public/404" unless current_user
  end

  def show
    @user = User.find(session[:user_id])
  end
end
