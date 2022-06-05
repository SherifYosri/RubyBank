class Seed
  def self.load_data
    # Admin User
    unless User.find_by_email(User.admin_email).present?
      User.create!(name: "Bank Admin", email: User.admin_email, password: "Super^Admin$BankTest%7000!")
    end
  end
end