class User < ApplicationRecord
 has_secure_password

  ROLES = ["student", "mentor"]

  validates :name, presence: { message: "cannot be blank" }
  validates :email, presence: { message: "cannot be blank" },
                    uniqueness: { message: "is already registered" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid"}
  validates :password, presence: { message: "Password cannot be blank" }, 
                       length: {minimum: 6, message:"should not be less than 6 characters"}
  validates :role, inclusion: { in: ROLES, message:"is not valid"}
  validates :introduction, length: {maximum:  500, message: "cannot be longer than 500 characters"}

end


