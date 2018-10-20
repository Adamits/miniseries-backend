require "rails_helper"
#include Warden::Test::Helpers
#Warden.test_mode!

RSpec.describe V1::Account::ProjectsController, :type => :controller do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:project) { user.projects.create(title: "test project") }

  describe "GET index" do
    it "has a 200 status code" do
      sign_in user
      get :index
      expect(response.status).to eq(200)
    end

    it "paginates projects" do
      sign_in user
      project.save
      10.times do |i|
        user.projects.create!(title: "#{i} comp")
      end
      get :index, {page: 1, per_page: 5}
      body = JSON.parse(response.body)
      expect(body.size).to eq(5)
    end
  end

  describe "GET show" do
    it "has a 200 status code" do
      sign_in user
      get :show, {id: project.id}
      expect(response.status).to eq(200)
    end
  end

  describe "GET edit" do
    it "has a 200 status code" do
      sign_in user
      get :edit, {id: project.id}
      expect(response.status).to eq(200)
    end
  end

  describe "PUT update" do
    it "has a 200 status code" do
      sign_in user
      put :update, id: project.id, project: {title: "updated title", description: "y0l0"}
      expect(response.status).to eq(200)
    end

    it "updates the project" do
      sign_in user
      put :update, id: project.id, project: {title: "updated title", description: "y0l0"}
      expect(project.reload.title).to eq("updated title")
      expect(project.reload.description).to eq("y0l0")
    end
  end

  describe "POST create" do
    it "has a 200 status code" do
      sign_in user
      post :create, project: {title: "test project2", description: "its for the 2nd test project"}
      expect(response.status).to eq(200)
    end

    it "creates a new project" do
      sign_in user
      post :create, project: {title: "test project2", description: "its for the 2nd test project"}
      expect(Project.last.title).to eq("test project2")
    end

    it "does not create a project that already exists" do
      sign_in user
      project.save
      response = post :create, project: {title: "test project"}
      body = JSON.parse(response.body)
      expect(body["errors"].first).to eq("Title has already been taken")
    end
  end

  describe "DELETE destroy" do
    it "has a 200 status code" do
      sign_in user
      delete :destroy, {id: project.id}
      expect(response.status).to eq(200)
    end

    it "destroys the project" do
      sign_in user
      delete :destroy, {id: project.id}
      expect(Project.find_by(id: project.id)).to eq(nil)
    end
  end
end
