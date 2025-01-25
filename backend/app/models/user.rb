require 'securerandom'
require 'bcrypt' 
require 'active_model'

class User
  include ActiveModel::Model
  include ActiveModel::Validations 

  attr_accessor :user_id, :name, :email, :password, :password_digest, :role, :introduction
  ROLES = ["student", "mentor"]

  validates :name, presence: { message: "Name cannot be blank" }
  validates :email, presence: { message: "Email cannot be blank" }, 
                    uniqueness:{ message: "Email is registered" }, 
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "Email is invalid"}
  validates :password, presence: { message: "Password cannot be blank" }, 
                       length: {minimum: 6, message:"Password should not be less than 6 characters"}
  
  validates :role, inclusion: { in: ROLES, message:"It is not a valid role"}
  validates :introduction, length: {maximum:  500, message: "Introduction cannot be longer than 500 characters"}

  def initialize_user(attributes = {})
    super
    self.user_id ||= SecureRandom.uuid
  end

  def create_user
    if valid?
      users = Rails.cache.read('users') || []
      existing_user = users.find{ |user| user[:email] == email}

      if existing_user
        error.add(:email, "is already registered")
        return false
      end

      hashed_password = BCrypt::Password.create(password)
      
      user_data = {
        user_id: user_id,
        name: name,
        password_digest:hashed_password,
        role:role,
        introduction: introduction
      }

      users << user_data
      Rails.cache.write('users', users)
      true
    else
      false
    end


end


