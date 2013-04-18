class UsersController < ApplicationController
  skip_before_filter :authorize, only: [:new, :create]
  before_filter :authorize_admin, only: [:destroy]

  # GET /music
  def show
    respond_to do |format|
      # show.html.erb
      format.html {
        @user = get_session_user
        @songs = @user.songs
      }
      # show.js.erb
      format.js {
        @user = get_session_user
        @songs = Song.search(@user, params[:search], params[:sort], params[:direction])
      }
      # ajax call
      format.json {
        songs = Song.find(params[:song_ids], order: "#{params[:sort] + " " + params[:direction]}")
        @json = { songs: [] }
        songs.each { |song| @json[:songs] << song.to_hash }
        render json: @json.to_json
      }
    end
  end

  # GET /signup
  def new
    @user = User.new
  end

  # GET /edit
  def edit
    @user = get_session_user
  end

  # POST /signup
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to music_path, notice: "User #{@user.name} was successfully created." }
      else
        format.html { render action: "new" }
      end
    end
  end

  # PUT /edit
  def update
    @user = get_session_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to music_path, notice: "User #{@user.name} was successfully updated." }
      else
        format.html { render action: "edit" }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user = User.find(params[:id])

    begin
      User.transaction do
        @user.destroy
        session[:user_id] = nil if @user.id == session[:user_id]
        flash.notice = "User #{@user.name} destroyed"
      end
    rescue Exception => e
      flash.notice = e.message
    end

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  # POST /music
  def upload
    song = Song.new
    song.update_attributes(:audio_file => params[:audio_file], :user_id => session[:user_id])
    if song.save
      tag = song.get_tag_hash
      song.update_attributes(title: tag[:title], artist: tag[:artist], album: tag[:album])
      message = "Song successfully uploaded"
    else
      message = "Song upload failed"
    end

    respond_to do |format|
      # Gets rendered in an iframe so it is possible to upload a file in a manner similar to ajax
      format.html {
        @user = get_session_user
        @songs = @user.songs
        render partial: 'music_list', locals: { message: message }
      }
    end
  end

  def destroy_music
    song_ids = params[:songs]

    begin
      Song.transaction do
        song_ids.each { |song_id| Song.find(song_id).destroy }
      end
      @message = "Songs deleted"
    rescue Exception => e
      @message = e.message
    end

    user = get_session_user
    @songs = Song.search(user, params[:search], params[:sort], params[:direction])

    respond_to do |format|
      format.html { redirect_to music_path }
      format.js
    end
  end
end