<h1 align="center"> Shopping Cart API </h1> <br>

<p align="center">
  Shopping cart API built completely in Rails 7
</p>

## Table of Contents

- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Features](#features)

## Getting Started

> 1. Clone/fork the project</br>
> 2. Write: Write: bundle install </br>
> 3. Write:  ```rake db:create```</br>
> 5. Add secret variables for AWS3 </br>
> 6. Run: ```rails s```

## Prerequisites

* Ruby 
* Ruby on Rails
* PostgradeSQL

## Extra Gems

# ```jwt``` - User authentication
# ```bcrypt``` - Password hashing
# ```rack-cors``` - Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible 
# ```aws-sdk-s3``` - AWS-S3 Storage

## Features

Shopping Cart API has the following features:

- User authentication with JWT
- Upload/Download CSV report of the user's cart with the help of AWS-S3
- Cart CRUD operations
- User can add, remove items from cart
- User can clear cart
- User can update the cart at once by changing the quantity of the cart items

## Hosting

The app is currently hosted on: <a href="https://shopping-cart-challenge-api.herokuapp.com">Heroku link</a>
