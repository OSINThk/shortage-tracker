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

products.each do |product|
  product.product_detail.create(
    price: rand(1..6),
    scarcity: rand(1..5)
  )
end

user = User.create


coordiantes = [
  '22.2276, 114.2178', # American club
  '22.392998428 114.203999184', # horse racing
  '22.274665568 114.155666044'

]
count = 0
ProductDetail.all.with_index do |pd|
  user.report.create(
    prroduct_detail: pd,
    coordinates: coordinates[count]
  )
  count += 1
end
