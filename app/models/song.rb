class Song < ActiveRecord::Base
  attr_accessible :audio_file, :user_id, :title, :artist, :album
  belongs_to :user
  has_attached_file :audio_file,
    :url => "/system/:class/:attachment/:id/:style/:filename",
    #:path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
    :path => "cs446/FRENCH/#{Rails.env}:url"
  validates :audio_file, presence: true, :attachment_content_type => { :content_type => [ 'audio/mp3', 'audio/mpeg', 'audio/x-m4a', 'audio/mp4' ] }

  @@filetypes = {
    'audio/mp3' => :mp3,
    'audio/mpeg' => :mp3,
    'audio/mpeg3' => :mp3,
    'audio/x-m4a' => :m4a,
    'audio/mp4' => :m4a
  }

  def self.search(user, query = nil, sort = nil, dir = nil)
    regex = "%#{query.split.join('%')}%" if query

    if user and query and sort and dir
      user.songs.where('title like ? or artist like ? or album like ?', regex, regex, regex).order(sort + " " + dir)
    elsif user and query
      user.songs.where('title like ? or artist like ? or album like ?', regex, regex, regex)
    elsif user and sort and dir
      user.songs.order(sort + " " + dir)
    elsif user
      user.songs
    end
  end

  def to_hash
    {
      title: self.title,
      artist: self.artist,
      url: self.audio_file.url,
      type: @@filetypes[self.audio_file_content_type]
    }
  end

  def get_tag_hash
    begin
      TagLib::FileRef.open(self.audio_file.path) do |file|
        tag = file.tag if file
        if tag
          tag.title ||= "Unknown"
          tag.artist ||= "Unknown"
          tag.album ||= "Unknown"
          { title: tag.title, artist: tag.artist, album: tag.album }
        else
          { title: "ERROR", artist: "ERROR", album: "ERROR" }
        end
      end
    rescue
      { title: "ERROR", artist: "ERROR", album: "ERROR" }
    end
  end
end