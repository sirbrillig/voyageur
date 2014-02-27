class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  has_many :locations, :dependent => :destroy, :order => :position
  has_many :trips, :dependent => :destroy
  audited

  def confirm
    self.confirmed_at = Time.now
  end

  def unconfirm
    self.confirmed_at = nil
  end
end
