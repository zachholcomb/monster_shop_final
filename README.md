# Monster Shop

## Background and Description

"Monster Shop" is a fictitious e-commerce platform where users can register to place items into a shopping cart and 'check out'. Users who work for a merchant can mark their items as 'fulfilled'; the last merchant to mark items in an order as 'fulfilled' will automatically set the order status to "shipped". Each user role will have access to some or all CRUD functionality for application models.


### Implementation Instructions
In order to set up and use this application locally:
 * Clone down the repository.
 * Run `bundle install`.
 * Run `rails db:{create,migrate,seed}` to setup the database.
 * Run `rails s`, navigate to your favorite web browser, enter `localhost:3000` in the address bar; you'll use this to interact with the development database.

### Functionality By Type of User

### Visitor
A **visitor** to this website is defined as anyone who is not currently logged in.

**Visitors** can:
 * visit the merchant index and show page to see all merchants and individual mechant information,
 * visit the items index and show page to see all items and individual item information,
 * add item reviews that can be seen on that item's show page,
 * add and remove items from a cart,
 * view the cart,
 * both increase and decrease quantity of each individual item in the cart,
 * register for an account profile on the site, and;
 * log into the site once an account has been created.

 **TIP:**  Before one can access user functionality, they must have registered with the site.  Registration requires name, full address, unique email, and matching password fields in order to complete successfully.
<img width="1434" alt="Screen Shot 2020-04-16 at 10 30 44 AM" src="https://user-images.githubusercontent.com/54481094/79481937-5f2c8d80-7fcd-11ea-8cfc-b957e44a58c5.png">

### Regular User
A **regular user** of this website has created an account, and, as such, has access to additional permissions.

A regular user can do all of the things a visitor can do, plus:
 * visit a profile page which displays all user information minus their password,
 * edit their profile,
 * change their password, and;
 * if the user has any open orders, they will have a "My Orders" link to view all of their orders.
 
#### Ordering Items
A regular user's order index page displays the following information:
 * the order's ID number,
 * the number of items within the order,
 * the status of the current order,
 * the total cost of the order, and;
 * dates corresponding to creation and edits.

If a regular user clicks on their order ID, the order show page displays all of the aforemention information, plus:
 * a breakdown by item, including - name, image, price, quantity, description, and subtotal, and;
 * if order has not been shipped yet, an option to cancel the order.

If a regular user would like to proceed with their finalized order, they have the ability to:
* go to their cart, and see a checkout option that, once clicked, will empty their cart.

TIP:  

### Merchant User
A **merchant user** of this website is essentially and employee that belongs to an associated storefront.  

This particular user is granted similar acess as a **regular user**, plus they can:
* create new items for their associated storefront,
* edit items associated to their storefront,
* delete items that don't have an active order pending,
* access a personalized merchant dashboard that displays employer and order information,
* access a personalized item dashboard that displays items belonging to their associated storefont,
* access to an orders show page that that displays order information along with the associated items for said order, and an option to fulfill the order.

### Administrator
An **administrator** of this website has the highest level of access, and they are able to executeactions that no other user can perform.

An administrator has all of the same permissions as regular users and merchant users _except_ access to adding items to the cart and the cart itself, plus:
* access a personalized admin dashboard that displays displays a breakdown of all orders, and each order has a link to the user who made the order,
* the ability to ship orders once they are fulfilled,
* access to an admin-only user index page that displays a list of all user names, a link to their indivdual profile, their roles, and when they were created.
* access to an admin-only merchant index page that displays the merchant user's name with a link to their individual profile, their location, and an option to both enable or disable that merchant.

**NOTE:** Disabling or enabling a merchant will deactivate or active their items, respectively!

### Logging Out
Every user has the ability to logging out.  When a user logs out, they are redirected to the site's home page.  If there are any items in the cart, they are removed.


### Schema Design 
Below is a diagram of this project's schema as well as the corresponding code:
![schema](https://user-images.githubusercontent.com/54481094/79493620-f817d480-7fde-11ea-96a6-17002bfbbaf2.png)


<img width="545" alt="Screen Shot 2020-02-27 at 7 11 22 PM" src="https://user-images.githubusercontent.com/54481094/79493672-0e259500-7fdf-11ea-940b-8b0ad1f2c4c5.png"><img width="545" alt="Screen Shot 2020-02-27 at 7 12 41 PM" src="https://user-images.githubusercontent.com/54481094/79493741-2990a000-7fdf-11ea-88a1-97f9e9a2daa1.png">


### Production Link
 * https://monster-shop-paired.herokuapp.com/


### Contributors
 * **Jesse Gietzen** - https://github.com/elguapogordo
 * **Steven Meyers** - 
 * **Zach Holcomb** - 
 * **Jordan Sewell** - https://github.com/jrsewell400