class AdminController < ApplicationController
  before_filter :authorize_admin

  def index
  	@admin = get_session_user

    if params[:search]
      regex = "%#{params[:search].split.join('%')}%"
      @users = User.where('name like ? or email like ? or role like ?', regex, regex, regex).order(:name)
    else
      @users = User.order(:name)
    end
  end

  def user
    @options = ["admin", "user"];
  	@user = User.find_by_id(params[:id])
    if params[:search]
      regex = "%#{params[:search]}%"
      @songs = @user.songs.where('title like ? or artist like ? or album like ?', regex, regex, regex)
    else
      @songs = @user.songs
    end
  end

  def update
    @options = ["admin", "user"];
    @user = User.find(params[:id])
    if params[:search]
      regex = "%#{params[:search]}%"
      @songs = @user.songs.where('title like ? or artist like ? or album like ?', regex, regex, regex)
    else
      @songs = @user.songs
    end

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to "/admin/user/#{@user.id}", notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "user" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
