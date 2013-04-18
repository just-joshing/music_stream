class AdminController < ApplicationController
  before_filter :authorize_admin

  def index
  	@admin = get_session_user
    @users = User.search(params[:search])
  end

  def user
    @options = ["admin", "user"];
  	@user = User.find(params[:id])
    @songs = Song.search(@user, params[:search])
  end

  def update
    @options = ["admin", "user"];
    @user = User.find(params[:id])
    @songs = Song.search(@user, params[:search])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to "/admin/user/#{@user.id}", notice: "User #{@user.name} was successfully updated." }
      else
        format.html { render action: "user" }
      end
    end
  end

  def destroy_music
    song_ids = params[:songs]

    begin
      Song.transaction do
        song_ids.each do |song_id|
          Song.find(song_id).destroy
        end
      end
      @message = "Songs deleted"
    rescue Exception => e
      @message = e.message
    end

    @user = User.find(params[:id])
    @songs = @user.songs

    respond_to do |format|
      format.html { render action: "user" }
    end
  end
end
