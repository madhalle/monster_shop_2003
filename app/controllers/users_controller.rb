class UsersController < ApplicationController
  def new
  end

  def index
    render file: "/public/404" unless current_admin?
  end

  def show
    render file: "/public/404" unless current_user
  end
end
