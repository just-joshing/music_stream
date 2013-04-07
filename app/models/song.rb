class Song < ActiveRecord::Base
  include UsersHelper

  attr_accessible :audio_file, :user_id, :title, :artist, :album
  belongs_to :user
  has_attached_file :audio_file,
    :url => "/system/:class/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  validates :audio_file, presence: true, :attachment_content_type => { :content_type => [ 'audio/mp3' ] }
end
