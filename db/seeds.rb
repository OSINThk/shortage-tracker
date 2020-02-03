# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

products = [
  'masks',
  'gloves',
  'bottled water'
].map { |name| Product.create(name: name) }

role = Role.create(name: 'admin')
user = User.create(email: "admin@example.com", password: "password", role: [role], confirmed_at: Time.now)

(1..100).each do |report_id|
  product_details = []
  products.each do |product|
    product_details << ProductDetail.create(
      product: product,
      price: rand(1..5),
      scarcity: rand(1..5),
      notes: "Product detail notes."
    )
  end

  Report.create(
    ip: "127.0.0.1",
    user: user,
    coordinates: "POINT(#{rand(114.0..114.5)} #{rand(22.0..23.0)} )",
    notes: "First report!",
    product_detail: product_details
  )
end
