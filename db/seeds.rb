# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
    user = User.create(username: "matija", password: "!safePass123")
    Item.create(name: "Sleeping bag", description: "A bag for sleep", price: 24.99, stock: 20)
    Item.create(name: "Bike", description: "A classic bicycle for cycling", price: 120.99, stock: 10)
    Item.create(name: "Computer", description: "Very good PC", price: 799.99, stock: 8)


