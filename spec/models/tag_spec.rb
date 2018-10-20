require "rails_helper"

RSpec.describe Tag, :type => :model do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:tag) { user.tags.create(name: "Dumb") }

  context "A tag" do
    it "has a name" do
      expect(tag.name).to eq("Dumb")
    end

    it "Can be voted on by a user" do
      vote = user.cast_vote("Vote::Positive", tag)
      expect(tag.votes.count).to eq(1)
    end

    it "Can be applied to some text" do
      project = user.projects.create(title: "test project")
      composition = user.compositions.create!(
        title: "first comp",
        content: "test content",
        project: project
      )
      user.tag(tag, composition, 0, 3)
      user.tag(tag, composition, 5, 8)

      expect(tag.taggings_count).to eq(2)
    end
  end
end
