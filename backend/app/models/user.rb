require 'securerandom'
require 'bcrypt' 
require 'active_model'

class User
  include ActiveModel::Model
  include ActiveModel::Validations 

  attr_accessor :user_id, :name, :email, :password, :password_digest, :role, :introduction
  ROLES = ["student", "mentor"]

  validates :name, presence: { message: "cannot be blank" }
  validates :email, presence: { message: "cannot be blank" },
                    format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/, message: "is invalid"}
  validates :password, presence: { message: "Password cannot be blank" }, 
                       length: {minimum: 6, message:"should not be less than 6 characters"}
  validates :role, inclusion: { in: ROLES, message:"is not valid"}
  validates :introduction, length: {maximum:  500, message: "cannot be longer than 500 characters"}

  def create_user

    unless email_unique?
      errors.add(:email, "is already registered")
      return false
    end

    if valid?
      Rails.logger.debug "It is a new account"
      self.user_id ||= SecureRandom.uuid 


      hashed_password = BCrypt::Password.create(password)

      user_data = {
        user_id: user_id,
        name: name,
        email: email,
        password_digest:hashed_password,
        role:role,
        introduction: introduction
      }

      users = Rails.cache.read("users") || []
      users << user_data
      Rails.cache.write("users", users)
      
      user_data
    else
      false
    end
  end

  private

  def email_unique?
    users = Rails.cache.read("users") || []
    users.none? { |user| user[:email] == email }
  end

end


