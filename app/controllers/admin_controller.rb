class AdminController < ApplicationController
  def index
  	@user = User.find_by_id(session[:user_id])
  end

  def user
  	@user = User.find_by_id(params[:id])
  end
end
