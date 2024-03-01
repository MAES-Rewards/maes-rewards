# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

User.create([
  {
    name: 'John Smith',
    email: 'smithj@mail.example.com',
    points: 100,
    is_admin: false
  },
  {
    name: 'Admin User',
    email: 'admin@mail.example.com',
    points: 0,
    is_admin: true
  },
  {
    name: 'Jaejin Cha',
    email: 'jaejin0109@tamu.edu',
    points: 30,
    is_admin: false
  }
]
           )

Reward.create!({
  name: 'MAES Hoodie',
  point_value: 100,
  dollar_price: 19.99,
  inventory: 20
}
              )

Activity.create!({
  name: 'Attend MAES Meeting',
  description: 'Attend an MAES meeting and record your attendance.',
  default_points: 10
}
                )

EarnTransaction.create!({
  user_id: 1,
  activity_id: 1,
  points: 200
}
                       )

SpendTransaction.create!({
  user_id: 1,
  reward_id: 1,
  points: 100
}
                        )
