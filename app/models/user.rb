class User < ActiveRecord::Base
  attr_accessor :password
  before_create {generate_token(:auth_token)}
  before_save :encrypt_password
  after_save :clear_password
  validates :email,:presence => true,:uniqueness => true
  validates :name,:phone_number,:presence => true
  validates_length_of :name,:in=>8..16
  EMAIL_REGEX = /\A[A-za-z0-9.-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/
  validates :email, :format => EMAIL_REGEX
  validates_format_of :phone_number ,:with => /\(?([0-9]{3})\)?([ .-]?)([0-9]{3})\2([0-9]{4})/
  validates_length_of :phone_number, :is => 10
  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
  def clear_password
    self.password = nil
  end
  def self.authenticate(email,password)
    #if EMAIL_REGEX.match(username_or_email)
      user = User.find_by_email(email)
      #else
      #user=User.find_by_name(username_or_password)
      #end
    if (user && user.password_hash) == BCrypt::Engine.hash_secret(password , user.password_salt)
      return user
    else
      return false
    end
    #def match_password(login_password="")
     # encrypted_password == #BCrypt::Engine.hash_secret(login_password,salt)
    #end
  end
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
  
end
