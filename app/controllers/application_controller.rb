class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authorize
  helper_method :get_session_user

  protected

  def get_session_user
    User.find_by_id(session[:user_id])
  end

  def authorize
    unless get_session_user
      redirect_to login_url, notice: 'Please log in'
    end
  end

  def authorize_admin
  	user = get_session_user
    unless user and user.role == 'admin'
      redirect_to :back
    end

    rescue ActionController::RedirectBackError
      redirect_to root_path
  end
end
