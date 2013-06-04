class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :admin, :email, :password, :encrypted_password, :password_confirmation, :remember_me, :created_at
  # attr_accessible :title, :body
  after_create :send_welcome_mail
  def send_welcome_mail
     UserMailer.new_user_notification(self).deliver
     UserMailer.welcome_email(self).deliver
  end
end
