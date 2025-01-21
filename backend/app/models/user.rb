require 'securerandom'
require 'bcrypt' 1547541353458

class User 
 def self.create(user_id, name, email, password, role, introduction)

  #validation
  validate_email(email)
  validate_password(password)
  validate_role(role)
  validate_introduction(introduction)

  # fetch data from the cache or initialize empty array
  users = Rails.cache.read('users')||[]

  # Check if the email has been registered
  user = users.find{ |user| user[:user_email] == user_email }

  if user.nil?
    Rails.logger.debug"Creating a new user."

    user = {
      user_id: SecureRandom.uuid,
      name: name,
      email: email,
      password_digest: hash_password(password),
      role: role,
      introduction:introduction
    }

    users << user
    Rails.cache.write('users',users)

    return user
  else
    Rails.logger.debug"The email exists."

    return nil
  end

  def self.hash_password(password)
    BCrypt::Password.create(password)
  end

  def self.validate_email(email)
    unless email =~ /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
      raise ArgumentError, "Invalid email format."
    end
  end

  def self.validate_password(password)
    if password.length < 6
      raise ArgumentError, "Password must be at least 6 characters long."
    end
  end

  def self.validate_role(role)
    allowed_roles = ["student", "mentor"]
    unless allowed_roles.include?(role)
      raise ArgumentError, "Invalid role."
    end
  end

  def self.validate_introduction(introduction)
    if introduction.length > 500
      raise ArgumentError, "Introduction cannot be longer than 500 characters."
    end
  end

end
