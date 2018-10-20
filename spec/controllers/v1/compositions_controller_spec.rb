require "rails_helper"
#include Warden::Test::Helpers
#Warden.test_mode!

RSpec.describe V1::CompositionsController, :type => :controller do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:project) { user.projects.create(title: "test project") }
  let(:composition) { user.compositions.create!(title: "first comp", content: "test content", project: project) }

  describe "GET index" do
    it "has a 200 status code" do
      sign_in user
      get :index
      expect(response.status).to eq(200)
    end

    it "paginates compositions" do
      sign_in user
      composition.save
      10.times do |i|
        user.compositions.create!(title: "#{i} comp", content: "test content", project: project)
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

    it "Returns taggings" do
      sign_in user
      tag = user.tags.create(name: "Dumb")
      user.tag(tag, composition, 0, 3)
      get :show, {id: composition.id}
      body = JSON.parse(response.body)
      expect(body["taggings"].size).to eq(1)
    end

    it "Returns tags" do
      sign_in user
      tag = user.tags.create(name: "Dumb")
      user.tag(tag, composition, 0, 3)
      get :show, {id: composition.id}
      body = JSON.parse(response.body)
      expect(body["tags"].size).to eq(1)
    end
  end

  describe "POST vote" do
    it "has a 200 status code for positive vote" do
      sign_in user
      post :vote, {id: composition.id, vote_type: "positive"}
      expect(response.status).to eq(200)
    end

    it "has a 200 status code for negative vote" do
      sign_in user
      post :vote, {id: composition.id, vote_type: "negative"}
      expect(response.status).to eq(200)
    end
  end

  describe "POST tag" do
    it "has a 200 status code" do
      sign_in user
      tag = user.tags.create(name: "funny", description: "Some text gave me a good chuckle")
      post :tag, {id: composition.id, tag_id: tag.id, start_span: 3, end_span: 8}
      expect(response.status).to eq(200)
    end
  end
end
