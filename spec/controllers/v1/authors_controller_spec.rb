require "rails_helper"

RSpec.describe V1::AuthorsController, :type => :controller do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }

  describe "GET index" do
    it "has a 200 status code" do
      get :index
      expect(response.status).to eq(200)
    end
  end

  describe "GET show" do
    it "has a 200 status code" do
      get :show, {id: user.id}
      expect(response.status).to eq(200)
    end

    it "Does not respond with senstive information" do
      get :show, {id: user.id}
      expect(response.body["password"]).to eq(nil)
    end
  end
end
