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


user = User.create!

coordinates = [
  '22.2276, 114.2178', # American club
  '22.392998428 114.203999184', # horse racing
  '22.274665568 114.155666044'

]
coordinates.each do |coords|
  user.report.create(
    product_detail: ProductDetail.new(price: rand(1..5), scarcity: rand(1..5)),
    coordinates: coords
  )
end
