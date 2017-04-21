namespace :admin do
  desc "Create admin"
  task init: :environment do
    admin = Admin.new email: "admin123@gmail.com", password: "password123",
      password_confirmation: "password123"
    admin.save!
  end

end
