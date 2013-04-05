class WelcomeController < ApplicationController
  skip_before_filter :authorize

  def index
  	if session[:user_id]
      redirect_to music_path
  	end
  end
end
