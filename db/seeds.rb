# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.find_or_create_by!(email: 'smithj@mail.example.com') do |user|
  user.name = 'John Smith'
  user.points = 100
  user.is_admin = false
end

Reward.find_or_create_by!(name: 'MAES Hoodie') do |reward|
  reward.point_value = 100
  reward.dollar_price = 19.99
  reward.inventory = 20
end

Activity.find_or_create_by!(name: 'Custom One-Time Activity') do |activity|
  activity.description = 'This activity exists to give points to members not associated with any specific activity.'
  activity.default_points = 0
end

Activity.find_or_create_by!(name: 'Attend MAES Meeting') do |activity|
  activity.description = 'Attend an MAES meeting and record your attendance.'
  activity.default_points = 10
end

EarnTransaction.find_or_create_by!(user_id: 1, activity_id: 1) do |transaction|
  transaction.points = 200
end

SpendTransaction.find_or_create_by!(user_id: 1, reward_id: 1) do |transaction|
  transaction.points = 100
end
