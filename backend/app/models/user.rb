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
      Rails.logger.debug "It is a new user"
      self.user_id = SecureRandom.uuid 

      hashed_password = BCrypt::Password.create(password)

      new_user = {
        user_id: user_id,
        name: name,
        email: email,
        password_digest:hashed_password,
        role:role,
        introduction: introduction
      }

      users = Rails.cache.read('users') || []
      users << new_user
      Rails.cache.write('users', users)
      
      return new_user

    else

      error.add(:base, "Invalid data. Cannot create user")
      return false
    end
  end

  private

  def email_unique?
    users = Rails.cache.read("users") || []
    users.none? { |user| user[:email] == email }
  end

  def self.all_users
      Rails.logger.debug "Cache before loading users: #{Rails.cache.read('users')}"
    users = Rails.cache.read('users')

    if users.nil? || users.empty?
      users = load_users_from_json
      Rails.cache.write('users', users)
       Rails.logger.debug "Users loaded from JSON and written to cache: #{users}"
    end
      Rails.logger.debug "Users loaded from JSON and written to cache: #{users}"
    users
  end

  # Method to load users from the users.json file
  def self.load_users_from_json
    json_file_path = Rails.root.join('db', 'users.json')
    
    if File.exist?(json_file_path)
      json_data = File.read(json_file_path)
      users = JSON.parse(json_data)
      users
    else
      Rails.logger.debug "No users.json file found"
      []
    end
  end

end


