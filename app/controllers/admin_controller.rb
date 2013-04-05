class AdminController < ApplicationController
  before_filter :authorize_admin

  def index
  	@admin = User.find_by_id(session[:user_id])
  	@users = User.order(:name)
  end

  def user
  	@user = User.find_by_id(params[:id])
  end
end
