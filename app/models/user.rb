require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :password, :password_confirmation, :if => Proc.new { @should_verify_password }
  validates_length_of :login, :within => 3..40
  validates_length_of :password, :within => 5..40, :if => Proc.new { @should_verify_password }
  validates_presence_of :login, :email, :salt, :name, :mentor_name
  validates_uniqueness_of :login, :email
  validates_confirmation_of :password, :if => Proc.new { @should_verify_password }
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "address invalid"
  validates_inclusion_of :enabled, :admin, :in => [true, false]
  
  has_many :subjects, :dependent => :destroy
  has_many :accomplishments, :dependent => :destroy
  has_many :logs, :dependent => :destroy
  has_many :log_reminders, :dependent => :destroy
  
  attr_protected :id, :salt
  
  attr_accessor :password, :password_confirmation
  
  def first_name
    (/^([A-Za-z']+)/.match(self.name))[1]
  end
  
  def initialize(*args)
    @should_verify_password = true
    super(*args)
  end
  
  def save_without_validating_password
    @should_verify_password = false
    r = self.save
    @should_verify_password = true
    r
  end
  
  def update_attributes_without_validating_password(attrs)
    @should_verify_password = false
    r = self.update_attributes(attrs)
    @should_verify_password = true
    r
  end
  
  def self.authenticate(login, pass)
    u = find(:first, :conditions => ["login = ?", login])
    return nil if u.nil?
    return u if User.encrypt(pass, u.salt) == u.hashed_password
  end
  
  def password=(pass)
    @password = pass
    self.salt = User.random_string(10) if !self.salt?
    self.hashed_password = User.encrypt(@password, self.salt)
  end
  
  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end
  
  protected
  
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end
  
  def self.random_string(len)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)]}
    return newpass
  end
  
end
