class User < ActiveRecord::Base
  attr_accessible :name, :email, :password, :password_confirmation, :avatar
  has_many :songs, dependent: :destroy
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :avatar, :attachment_content_type => { :content_type => [ 'image/jpeg', 'image/png', 'image/bmp', 'image/gif' ] }
  has_secure_password
  has_attached_file :avatar,
    :styles => { :small => '150x150>', :thumb => '100x100#' },
    :default_url => "/assets/default_:style.jpg",
    :url => "/system/:class/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"
  before_destroy :ensure_an_admin_remains

  def is_admin?
    self.role == 'admin'
  end

  private

  def ensure_an_admin_remains
    unless !is_admin? or User.count(:conditions => 'role = "admin"') > 1
      raise "Can't delete last admin"
    end
  end
end
