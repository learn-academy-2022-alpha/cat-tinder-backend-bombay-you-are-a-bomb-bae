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
  it "doesn't create a cat without a name" do
    cat_params = {
      cat: {
        age: 2,
        enjoys: "Walks in the park",
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    post '/cats', params: cat_params
    expect(response.status).to eq 422
    json = JSON.parse(response.body)
    expect(json['name']).to include "can't be blank"
  end
  it "doesn't create a cat without an age" do
    cat_params = {
      cat: {
        name: 'Felix',
        enjoys: "Walks in the park",
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    post '/cats', params: cat_params
    expect(response.status).to eq 422
    json = JSON.parse(response.body)
    expect(json['age']).to include "can't be blank"
  end
  it "doesn't create a cat without an enjoy" do
    cat_params = {
      cat: {
        name: 'Felix',
        age: 22,
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    post '/cats', params: cat_params
    expect(response.status).to eq 422
    json = JSON.parse(response.body)
    expect(json['enjoys']).to include "can't be blank"
  end
  it "doesn't create a cat without an image" do
    cat_params = {
      cat: {
        name: 'Felix',
        age: 22,
        enjoys: 'Walks in the park'
      }
    }
    post '/cats', params: cat_params
    expect(response.status).to eq 422
    json = JSON.parse(response.body)
    expect(json['image']).to include "can't be blank"
  end
  it "doesn't create unless enjoys is more than 10 characters" do
    cat_params = {
      cat: {
        name: 'Felix',
        age: 22,
        enjoys: 'duh',
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    post '/cats', params: cat_params
    expect(response.status).to eq 422
    json = JSON.parse(response.body)
    expect(json['enjoys']).to_not be_empty
  end
  it "doesn't update if not valid" do
    Cat.create(
      name: 'Felix',
      age: 2,
      enjoys: 'Walks in the park',
      image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
    )
    cat_felix = Cat.first
    cat_params = {
      cat: {
        name: "",
        age: 2,
        enjoys: "Walks in the park",
        image: 'https://images.unsplash.com/photo-1529778873920-4da4926a72c2?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1036&q=80'
      }
    }
    patch "/cats/#{cat_felix.id}", params: cat_params
    expect(response.status).to eq 422
    json = JSON.parse(response.body)
    expect(json['name']).to include "can't be blank"
  end
end
