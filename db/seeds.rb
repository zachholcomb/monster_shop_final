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

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
candy_shop = Merchant.create(name: "50 Cent's Candy Shop", address: '512 Electric Avenue', city: 'Silverthorne', state: 'CO', zip: 81103, enabled?: false)

#merchant_discounts
discount1 = bike_shop.discounts.create!(name: "Flash Sale", percentage: 10, item_amount: 5)
discount2 = bike_shop.discounts.create!(name: "Fifty Percent Off 50 items", percentage: 25, item_amount: 10)

#users
regular = User.create(name: "Regular User", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "user@example.com", password: "password_regular")
test_merchant = dog_shop.users.create(name: "Dog Shop Employee", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "merchant@example.com", password: "password_merchant", role: 1)
dog_merchant = dog_shop.users.create(name: "Dog Shop Employee", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "dog_merchant@example.com", password: "1234", role: 1)
bike_merchant = bike_shop.users.create(name: "Bike Shop Employee", address:"123 Real St.", city: "Boudler", state: "CO", zip: "80311", email: "bike_merchant@example.com", password: "1234", role: 1)
candy_merchant = candy_shop.users.create(name: "Candy Shop Employee", address:"311 Realfake St.", city: "Longmont", state: "CO", zip: "80001", email: "candy_merchant@example.com", password: "1234", role: 1)
admin = User.create(name: "Admin User", address:"321 Fake St.", city: "Arvada", state: "CO", zip: "80301", email: "admin@example.com", password: "password_admin", role: 2)
customer1 = User.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', email: "user1@example.com", password: "user1")
customer2 = User.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', email: "user2@example.com", password: "user2")

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
tire2 = bike_shop.items.create(name: "Goodyear", description: "They're good for a year!", price: 150, image: "https://www.adventurecycling.org/sites/default/assets/Image/AdventureCyclist/OnlineFeatures/2018/Goodyear%20Tires/LoganVB_9829.jpg", inventory: 5)
pedal = bike_shop.items.create(name: "Bike Pedal", description: "It's a bike pedal.", price: 75, image: "https://imgaz2.staticbg.com/thumb/large/oaupload/ser1/banggood/images/C0/13/5b830fee-2941-464d-9c06-bd4c5dc6c1b8.jpg", inventory: 10)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "https://media.hardwarestore.com/catalog/product/cache/75eed2686e01eb22cb4050b2f40ddf97/1/2/124988_front500_p01.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
dog_bowl = dog_shop.items.create(name: "Dog Bowl", description: "Great dog bowl!", price: 7, image: "https://www.talltailsdog.com/pub/media/catalog/product/cache/a0f79b354624f8eb0e90cc12a21406d2/u/n/untitled-6.jpg", inventory: 32)
dog_ball = dog_shop.items.create(name: "Dog Ball", description: "Awesome dog ball!", price: 5, image: "https://img.chewy.com/is/image/catalog/59155_MAIN._AC_SL1500_V1518033665_.jpg", inventory: 20)
dog_leash = dog_shop.items.create(name: "Dog Leash", description: "Sturdy dog leash!", price: 10, image: "https://cdn.shopify.com/s/files/1/1728/3089/products/max_and_neo_small_dog_leash_black.jpg?v=1555617800", inventory: 11)

#candy_shop items
lollipop = candy_shop.items.create(name: "Lollipop", description: "Sweet!", price: 13, image: "https://hotlix.com/wp-content/uploads/2018/07/ant-individual-watermelon.jpg", inventory: 8)
tootsie_roll = candy_shop.items.create(name: "Tootsie Roll", description: "Brown chocolate log", price: 40, image: "https://upload.wikimedia.org/wikipedia/commons/2/20/Tootsie-Roll-Log-Large.jpg", inventory: 17)    
pop_rocks = candy_shop.items.create(name: "Pop Rocks", description: "Keep it poppin'!", price: 5, image: "https://www.bulkpricedfoodshoppe.com/wp-content/uploads/2017/02/product_6_9_699862.jpg", inventory: 50)

#orders
order0 = customer1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 0)
order1 = customer1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 3)
order2 = customer2.orders.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', status: 2)
order3 = customer1.orders.create(name: 'Steve Meyers', address: '555 Free St.', city: 'Plano', state: 'TX', zip: '88992', status: 1)
order4 = customer2.orders.create(name: 'Jordan Sewell', address: '123 Fake St.', city: 'Arvada', state: 'CO', zip: '80301', status: 0)

#orders on items
ItemOrder.create(item: tire, order: order0, price: tire.price, quantity: 2)
ItemOrder.create(item: dog_bone, order: order1, price: dog_bone.price, quantity: 4)
ItemOrder.create(item: pull_toy, order: order2, price: pull_toy.price, quantity: 7)
ItemOrder.create(item: dog_ball, order: order2, price: dog_ball.price, quantity: 3)
ItemOrder.create(item: dog_bowl, order: order2, price: dog_bowl.price, quantity: 2)
ItemOrder.create(item: pull_toy, order: order3, price: pull_toy.price, quantity: 4)
ItemOrder.create(item: dog_leash, order: order4, price: dog_leash.price, quantity: 3)
ItemOrder.create(item: tire, order: order4, price: tire.price, quantity: 2)