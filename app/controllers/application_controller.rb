class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize

  protected

  def authorize
  	user = User.find_by_id(session[:user_id])
    unless user and user.role == 'admin'
      redirect_to login_url, notice: 'Please log in'
    end
  end
end
