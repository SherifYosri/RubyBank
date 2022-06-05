# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Admin User
# For the sake of security on production db, super admin should be created manually via Rails Console
unless Rails.env.production? || User.find_by_email(User.admin_email).present?
  User.create!(name: "Bank Admin", email: User.admin_email, password: "Super^Admin$Bank%7000!")
end