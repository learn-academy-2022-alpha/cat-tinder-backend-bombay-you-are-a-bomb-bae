# README

rails new cat-tinder-backend-bombay-you-are-a-bom-bae -d postgresql -T
cd cat-tinder-backend-bombay-you-are-a-bom-bae
rails db:create
bundle add rspec-rails
rails generate rspec:install

rails server

git branch -M main
git push -u origin main
git checkout -b main
git branch
git add .
git commit -m "initial rails commit"
git push origin main
rails server
git branch
git checkout -b backend-structure
code .

rails generate resource Cat name:string age:integer enjoys:text image:text
rails db:migrate
rspec spec

added to seeds.rb
cats = [
  {
    name: 'Felix',
    age: 2,
    enjoys: 'Long naps on the couch, and a warm fire.',
    image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
  },
  {
    name: 'Homer',
    age: 12,
    enjoys: 'Food mostly, really just food.',
    image: 'https://images.unsplash.com/photo-1573865526739-10659fec78a5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1015&q=80'
  },
  {
    name: 'Jack',
    age: 5,
    enjoys: 'Furrrrociously hunting bugs.',
    image: 'https://images.unsplash.com/photo-1492370284958-c20b15c692d2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1049&q=80'
  }
]

cats.each do |each_cat|
  Cat.create each_cat
  puts "creating cat #{each_cat}"
end

rails db:seed
rails c
Cat.all

Added a couple more cats

changed application_controller.rb
class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
end

added to gemfile
gem 'rack-cors', :require => 'rack/cors'

added cors.rb to config/initilizers
added to cors.rb
# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin AJAX requests.

# Read more: https://github.com/cyu/rack-cors

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # <- change this to allow requests from any domain while in development.

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end

$ bundle



