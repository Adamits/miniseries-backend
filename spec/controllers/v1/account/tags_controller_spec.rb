require "rails_helper"

RSpec.describe V1::Account::TagsController, :type => :controller do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:tag) { user.tags.create(name: "Dumb") }

  describe "GET index" do
    it "has a 200 status code" do
      sign_in user
      get :index
      expect(response.status).to eq(200)
    end

    it "paginates tags" do
      sign_in user
      tag.save
      10.times do |i|
        user.tags.create!(name: "#{i} comp")
      end
      get :index, {page: 1, per_page: 5}
      body = JSON.parse(response.body)
      expect(body.size).to eq(5)
    end
  end

  describe "GET show" do
    it "has a 200 status code" do
      sign_in user
      get :show, {id: tag.id}
      expect(response.status).to eq(200)
    end
  end

  describe "GET edit" do
    it "has a 200 status code" do
      sign_in user
      get :edit, {id: tag.id}
      expect(response.status).to eq(200)
    end
  end

  describe "PUT update" do
    it "has a 200 status code" do
      sign_in user
      put :update, id: tag.id, tag: {name: "updated name", description: "y0l0"}
      expect(response.status).to eq(200)
    end

    it "updates the tag" do
      sign_in user
      put :update, id: tag.id, tag: {name: "updated name", description: "y0l0"}
      expect(tag.reload.name).to eq("updated name")
      expect(tag.reload.description).to eq("y0l0")
    end
  end

  describe "POST create" do
    it "has a 200 status code" do
      sign_in user
      post :create, tag: {name: "test tag2", description: "its for the 2nd test tag"}
      expect(response.status).to eq(200)
    end

    it "creates a new tag" do
      sign_in user
      post :create, tag: {name: "test tag2", description: "its for the 2nd test tag"}
      expect(Tag.last.name).to eq("test tag2")
    end

    it "does not create a tag that already exists" do
      sign_in user
      tag.save
      response = post :create, tag: {name: "Dumb"}
      body = JSON.parse(response.body)
      expect(body["errors"].first).to eq("Name has already been taken")
    end
  end

  describe "DELETE destroy" do
    it "has a 200 status code" do
      sign_in user
      delete :destroy, {id: tag.id}
      expect(response.status).to eq(200)
    end

    it "destroys the tag" do
      sign_in user
      delete :destroy, {id: tag.id}
      expect(Tag.find_by(id: tag.id)).to eq(nil)
    end
  end
end
