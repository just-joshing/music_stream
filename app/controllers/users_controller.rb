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
        
        if params[:search]
          regex = "%#{params[:search].split.join('%')}%"
          @songs = @user.songs.where('title like ? or artist like ? or album like ?', regex, regex, regex)
        else
          @songs = @user.songs
        end
      }
      # ajax call
      format.json {
        songs = Song.find(params[:song_ids])
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
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /edit
  def update
    @user = get_session_user

    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to music_path, notice: "User #{@user.name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
      format.json { head :no_content }
    end
  end

  # POST /music
  def upload
    song = Song.new
    song.update_attributes(:audio_file => params[:audio_file], :user_id => session[:user_id])
    if song.save
      TagLib::FileRef.open(song.audio_file.path) do |file|
        tag = file.tag
        if file and tag
          tag.title ||= "Unknown"
          tag.artist ||= "Unknown"
          tag.album ||= "Unknown"
          song.update_attributes(:title => tag.title, :artist => tag.artist, :album => tag.album)
        else
          song.update_attributes(:title => "ERROR", :artist => "ERROR", :album => "ERROR")
        end
      end

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
        song_ids.each do |song_id|
          Song.find(song_id).destroy
        end
      end
      @message = "Songs deleted"
    rescue Exception => e
      @message = e.message
    end

    respond_to do |format|
      format.html { redirect_to music_path }
      format.js { @songs = get_session_user.songs }
    end
  end
end