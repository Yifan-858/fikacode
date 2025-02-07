# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.create!([
  {
    
    name: "Student One",
    email: "student1@example.com",
    password: "password123",
    role: "student",
    introduction: "I want to learn Ruby."
  },
  {
    
    name: "Student Two",
    email: "student2@example.com",
    password: "password123",
    role: "student",
    introduction: "I'm studying Javascript. And I have 2 years of experience with Ruby."
  },
  {
    
    name: "Mentor One",
    email: "mentor1@example.com",
    password: "password123",
    role: "mentor",
    introduction: "I'm a mentor with 5 years of experience in backend."
  },
  {
    
    name: "Mentor Two",
    email: "mentor2@example.com",
    password: "password123",
    role: "mentor",
    introduction: "I guide students in web development. Javascript, React, Typescript."
  },
  {
   
    name: "Mentor Three",
    email: "mentor3@example.com",
    password: "password123",
    role: "mentor",
    introduction: "I can help with questions regarding C#."
  }
])