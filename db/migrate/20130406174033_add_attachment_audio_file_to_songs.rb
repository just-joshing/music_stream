class AddAttachmentAudioFileToSongs < ActiveRecord::Migration
  def self.up
    change_table :songs do |t|
      t.attachment :audio_file
    end
  end

  def self.down
    drop_attached_file :songs, :audio_file
  end
end
