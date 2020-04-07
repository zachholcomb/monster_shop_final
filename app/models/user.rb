class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password_digest, require: true

  has_secure_password

  def default?
    role == 0
  end

  def merchant?
    role == 1
  end
end
