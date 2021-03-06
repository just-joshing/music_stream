class SessionsController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]

  def new
    if session[:user_id]
      redirect_to music_path
    end
  end

  def create
  	user = User.find_by_email(params[:email])
  	if user and user.authenticate(params[:password])
  		session[:user_id] = user.id
  		redirect_to music_path
  	else
  		redirect_to login_url, alert: 'Invalid user/password combination'
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to login_url, notice: 'Successfully logged out'
  end
end
