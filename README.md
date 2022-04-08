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

Endpoints

git checkout -b api-endpoints

rails routes

 Prefix Verb   URI Pattern                                                                                       Controller#Action
                                    cats GET    /cats(.:format)                                                                                   cats#index
                                         POST   /cats(.:format)                                                                                   cats#create
                                 new_cat GET    /cats/new(.:format)                                                                               cats#new
                                edit_cat GET    /cats/:id/edit(.:format)                                                                          cats#edit
                                     cat GET    /cats/:id(.:format)                                                                               cats#show
                                         PATCH  /cats/:id(.:format)                                                                               cats#update
                                         PUT    /cats/:id(.:format)                                                                               cats#update
                                         DELETE /cats/:id(.:format)                                                                               cats#destroy

added empty methods to cats_controller.rb
class CatsController < ApplicationController

  def index
  end

  def create
  end

  def update
  end

  def destroy
  end

end

added to cats_requests_spec.rb

require 'rails_helper'

RSpec.describe "Cats", type: :request do
  describe "GET /index" do
    it "gets a list of cats" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )

      # Make a request
      get '/cats'

      cat = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(cat.length).to eq 1
    end
  end
end

rspec spec/requests
test red

def index
  cats = Cat.all
  render json: cats
end

rspec spec/requests
test green

added to cats_requests_spec.rb

describe "POST /create" do
  it "creates a cat" do
    # The params we are going to send with the request
    cat_params = {
      cat: {
        name: 'Pinky',
        age: 4,
        enjoys: 'Meow Mix, and plenty of sunshine.',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }

    # Send the request to the server
    post '/cats', params: cat_params

    # Assure that we get a success back
    expect(response).to have_http_status(200)

    # Look up the cat we expect to be created in the db
    cat = Cat.first

    # Assure that the created cat has the correct attributes
    expect(cat.name).to eq 'Pinky'
  end
end

rspec spec/requests
red

added to controller

    def create
        # Create a new cat
        cat = Cat.create(cat_params)
        render json: cat
    end

    def cat_params
        params.require(:cat).permit(:name, :age, :enjoys, :image)
    end

added to spec

describe "PATCH /update" do
    it "updates a cat" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )
      cat_felix = Cat.first
      # The params we are going to send with the request
      cat_params = {
        cat: {
          name: 'Poppy',
          age: 2,
          enjoys: 'Walks in the park',
          image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
        }
      }
  
      # Send patch request with id of the instance from the db
      patch "/cats/#{cat_felix.id}", params: cat_params

      # Look up the cat we expect to be created in the db
      cat_finder = Cat.find(cat_felix.id)
  
      # Assure that we get a success back
      expect(response).to have_http_status(200)
  
      # Assure that the created cat has the correct attributes
      expect(cat_finder.name).to eq 'Poppy'
    end
  end

rspec spec/requests
red

added to controller

def update
        cat = Cat.find(params[:id])
        cat.update(cat_params)
        if cat.valid?
            render json: cat
        else
            render json: cat.errors
        end
    end

added to spec

  describe "DELETE /destroy" do
    it "deletes a cat from the db" do
      Cat.create(
        name: 'Felix',
        age: 2,
        enjoys: 'Walks in the park',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      )
      cat_felix = Cat.first
  
      # Send delete request with id of the instance from the db
      delete "/cats/#{cat_felix.id}"
  
      # Assure that we get a success back
      expect(response).to have_http_status(200)

      cat_deleted = Cat.all
  
      # Assure the cat has been deleted
      expect(cat_deleted).to be_empty
    end
  end

rspec spec/requests
red
  added to spec

    def destroy
        cat = Cat.find(params[:id])
        if cat.destroy
            render json: cat
        else
            render json: cat.errors
        end
    end

rspec spec/requests
green
