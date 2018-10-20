require "rails_helper"

RSpec.describe User, :type => :model do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:tag) { user.tags.create(name: "Dumb") }

  context "A user" do
    it "Can create a project" do
      user.projects.create(title: "test project")

      expect(Project.first.user).to eq(user)
    end

    it "Has a compositions_count" do
      project = user.projects.create(title: "test project")
      user.compositions.create!(title: "first comp", content: "test content", project: project)
      user.compositions.create!(title: "second comp", content: "test content", project: project)

      expect(user.compositions_count).to eq(2)
    end

    it "Casts a vote" do
      project = user.projects.create(title: "test project")
      composition = user.compositions.create!(title: "first comp", content: "test content", project: project)
      user.cast_vote("Vote::Negative", composition)
      vote = user.votes.last

      expect(user.votes.count).to eq(1)
      expect(vote.user_id).to eq(user.id)
      expect(user.has_voted_on?(composition)).to eq(true)
    end

    it 'Cannot cast multiple votes on the same votable' do
      project = user.projects.create(title: "test project")
      composition = user.compositions.create!(title: "first comp", content: "test content", project: project)
      user.cast_vote("Vote::Negative", composition)

      expect(user.cast_vote("Vote::Negative", composition)).to be false
      expect(user.errors.messages[:base].last).to eq  "You do not have permission to vote on this!"
    end
  end
end
