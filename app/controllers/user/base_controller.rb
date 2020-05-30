class User::BaseController < ApplicationController
  before_action :restrict_access

  def restrict_access
    render file: "/public/404" unless current_user
  end
end
