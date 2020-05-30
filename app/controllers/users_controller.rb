class UsersController < ApplicationController
  def new
  end

  def index
    render file: "/public/404" unless current_admin?
  end

  def show
    render file: "/public/404" unless current_user
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      flash[:notice] = 'Success! You are now registered and logged in as a User!'
      redirect_to '/profile'
    else
      flash[:notice] = user.errors.full_messages.to_sentence
      render "new"
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
