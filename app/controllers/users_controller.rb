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
      flash[:notice] = 'Success! You are now registered and logged in as a User!'
      redirect_to '/profile'
    elsif User.unique_email?(user.email) == false
      flash[:notice] = "This email address is registered to another account"
      render "new"
    else
      flash[:notice] = 'All fields are required. Please enter information in all fields.'
      redirect_to '/register'
    end
  end

  private

  def user_params
    params.permit(:name, :address, :city, :state, :zip, :email, :password, :password_confirmation)
  end
end
