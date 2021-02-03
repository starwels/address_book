# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


ActiveRecord::Base.transaction do
  organization = Organization.create!(name: 'STRV')

  admin = User.new(email: "admin@strv.com", password: 'admin1', role: :admin)
  admin.organizations.push(organization)
  admin.save!

  user = User.new(email: "user@strv.com", password: 'user11')
  user.organizations.push(organization)
  user.save!
end
