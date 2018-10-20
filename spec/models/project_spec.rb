require "rails_helper"

RSpec.describe Project, :type => :model do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:project) { user.projects.create(title: "test project") }

  context "A project" do
    it "Requires a title" do
      p = user.projects.create()
      expect(p).to_not be_valid
    end

    it "Has 1 unpublished composition" do
      composition_params = {
        user: user,
        title: "first comp",
        content: "test content"
      }
      composition = project.compositions.create!(composition_params)

      expect(project.reload.compositions.count).to eq(1)
    end

    it "Has 0 published compositions" do
      composition_params = {
        user: user,
        title: "first comp",
        content: "test content"
      }
      composition = project.compositions.create!(composition_params)

      expect(project.reload.published_compositions_count).to eq(0)
    end

    it "Has 1 published composition" do
      composition_params = {
        user: user,
        title: "first comp",
        content: "test content"
      }
      composition = project.compositions.create!(composition_params)
      composition.publish

      expect(project.reload.published_compositions_count).to eq(1)
    end

    it "Has a most recently published composition" do
      composition_params = {
        user: user,
        title: "first comp",
        content: "test content"
      }
      composition = project.compositions.create!(composition_params)
      composition.publish

      composition2_params = {
        user: user,
        title: "second comp",
        content: "test content"
      }
      composition2 = project.compositions.create!(composition2_params)
      composition2.publish

      expect(project.published_compositions_count).to eq(2)
      expect(project.most_recently_published_composition).to eq(composition2)
    end

    it "Can be voted on" do
      user.cast_vote("Vote::Positive", project)
      vote = user.votes.last

      expect(project.votes.count).to eq(1)
      expect(vote.votable_id).to eq(project.id)
    end
  end
end
