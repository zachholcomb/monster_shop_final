# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Merchant.destroy_all
Item.destroy_all
ItemOrder.destroy_all
User.destroy_all

#users 
admin = User.create(name: "Jordan Sewell", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "chunky_admin@example.com", password: "123password")

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 5)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)

#orders
order1 = Order.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992')     
order2 = Order.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301')

#orders on items
ItemOrder.create(item: tire, order: order1, price: tire.price, quantity: 5)
ItemOrder.create(item: pull_toy, order: order2, price: pull_toy.price, quantity: 7)
ItemOrder.create(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
ItemOrder.create(item: tire, order: order2, price: tire.price, quantity: 5)
ItemOrder.create(item: dog_ball, order: order2, price: dog_ball.price, quantity: 3)
ItemOrder.create(item: dog_bowl, order: order2, price: dog_bowl.price, quantity: 2)
ItemOrder.create(item: tire2, order: order1, price: tire.price, quantity: 1)