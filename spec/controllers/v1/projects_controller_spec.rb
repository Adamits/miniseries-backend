require "rails_helper"
#include Warden::Test::Helpers
#Warden.test_mode!

RSpec.describe V1::ProjectsController, :type => :controller do
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
end
