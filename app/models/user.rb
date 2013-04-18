class User < ActiveRecord::Base
  before_destroy :ensure_an_admin_remains
  attr_accessible :name, :email, :password, :password_confirmation, :avatar, :role, :upload_limit
  has_many :songs, dependent: :destroy
  validates :upload_limit, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: /^[a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z]{2,4}$/ }
  validates :avatar, :attachment_content_type => { :content_type => [ 'image/jpeg', 'image/png', 'image/bmp', 'image/gif' ] }
  has_secure_password
  has_attached_file :avatar,
    :styles => { :small => '150x150>', :thumb => '100x100#' },
    :default_url => "/assets/default_:style.jpg",
    :url => "/system/:class/:attachment/:id/:style/:filename",
    :path => ":rails_root/public/system/:class/:attachment/:id/:style/:basename.:extension"

  def is_admin?
    self.role == 'admin'
  end

  def self.search(query)
    if query
      regex = "%#{query.split.join('%')}%"
      User.where('name like ? or email like ? or role like ?', regex, regex, regex).order("lower(name)")
    else
      User.order("lower(name)")
    end
  end

  private

  def ensure_an_admin_remains
    unless !is_admin? or User.count(:conditions => 'role = "admin"') > 1
      raise "Can't delete last admin"
    end
  end
end
