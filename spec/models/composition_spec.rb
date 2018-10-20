require "rails_helper"

RSpec.describe Composition, :type => :model do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:project) { user.projects.create(title: "test project") }
  let(:composition) { user.compositions.create!(title: "first comp", content: "test content", project: project) }
  let(:tag) { user.tags.create(name: "Dumb") }

  context "A normal composition" do
    it "has order 0" do
      expect(composition.order).to eq(0)
    end

    it "Updates its content" do
      expect(composition.content).to eq("test content")
      composition.content = "Yeah right!"
      composition.save!
      expect(composition.content).to eq("Yeah right!")
    end

    it "Gets an incremented order for a second composition" do
      expect(composition.order).to eq(0)
      composition2 = user.compositions.create(title: "second comp", content: "more test content", project: project)
      expect(composition2.order).to eq(1)
    end

    it "Can be published" do
      composition.publish
      expect(composition.published).to eq(true)
    end

    it "Can be tagged" do
      user.tag(tag, composition, 0, 3)
      user.tag(tag, composition, 5, 8)

      expect(composition.taggings_count).to eq(2)
    end

    it "Can be voted on" do
      user.cast_vote("Vote::Negative", composition)
      vote = user.votes.last

      expect(composition.votes.count).to eq(1)
      expect(vote.votable_id).to eq(composition.id)
    end

    it "Has many votes" do
      user2 = User.create(email: "dogs@gmail.com", password: "test_pass")
      user.cast_vote("Vote::Negative", composition)
      user2.cast_vote("Vote::Positive", composition)

      expect(composition.votes.count).to eq(2)
      expect(composition.positive_votes.count).to eq(1)
      expect(composition.negative_votes.count).to eq(1)
    end
  end
end
