class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password_digest, require: true
  has_many :merchant_employees
  has_many :merchants, through: :merchant_employees
  has_secure_password
  enum role: %w(default merchant admin)
end
