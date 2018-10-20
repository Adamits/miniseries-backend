require "rails_helper"
#include Warden::Test::Helpers
#Warden.test_mode!

RSpec.describe V1::Account::CompositionsController, :type => :controller do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:project) { user.projects.create(title: "test project") }
  let(:composition) { user.compositions.create(title: "test composition", content: "test content", project: project) }

  describe "GET index" do
    it "has a 200 status code" do
      sign_in user
      get :index
      expect(response.status).to eq(200)
    end

    it "paginates Compositions" do
      sign_in user
      composition.save
      10.times do |i|
        user.compositions.create!(title: "#{i} comp", content: "#{i} content", project: project)
      end
      get :index, {page: 1, per_page: 5}
      body = JSON.parse(response.body)
      expect(body.size).to eq(5)
    end
  end

  describe "GET show" do
    it "has a 200 status code" do
      sign_in user
      get :show, {id: composition.id}
      expect(response.status).to eq(200)
    end
  end

  describe "GET edit" do
    it "has a 200 status code" do
      sign_in user
      get :edit, id: composition.id
      expect(response.status).to eq(200)
    end
  end

  describe "PUT update" do
    it "has a 200 status code" do
      sign_in user
      put :update, id: composition.id, composition: {title: "updated title", description: "y0l0"}
      expect(response.status).to eq(200)
    end

    it "updates the composition" do
      sign_in user
      put :update, id: composition.id, composition: {title: "updated title", description: "y0l0"}
      expect(composition.reload.title).to eq("updated title")
      expect(composition.reload.description).to eq("y0l0")
    end
  end

  describe "POST create" do
    it "has a 200 status code" do
      sign_in user
      post :create, composition: {title: "test composition2", description: "its for the 2nd test composition", project: project}
      expect(response.status).to eq(200)
    end

    it "creates a new composition" do
      sign_in user
      post :create, composition: {title: "test composition2", description: "its for the 2nd test composition"}
      expect(composition.last.title).to eq("test composition2")
    end

    it "does not create a composition that already exists" do
      sign_in user
      composition.save
      response = post :create, composition: {title: "test composition"}
      body = JSON.parse(response.body)
      expect(body["errors"].first).to eq("Title has already been taken")
    end
  end

  describe "DELETE destroy" do
    it "has a 200 status code" do
      sign_in user
      delete :destroy, {id: composition.id}
      expect(response.status).to eq(200)
    end

    it "destroys the composition" do
      sign_in user
      delete :destroy, {id: composition.id}
      expect(composition.find_by(id: composition.id)).to eq(nil)
    end
  end
end
