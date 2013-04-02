class User < ActiveRecord::Base
  attr_accessible :name, :password, :password_confirmation, :avatar
  validates :name, presence: true, uniqueness: true
  has_secure_password
  has_attached_file :avatar,
    :styles => { :small => '150x150>', :thumb => '100x100#' },
    :default_url => "/assets/default_:style.jpg"
  after_destroy :ensure_an_admin_remains

  private

  def ensure_an_admin_remains
    if User.count.zero?
      raise "Can't delete last admin"
    end
  end
end
