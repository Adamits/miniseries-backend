require "rails_helper"

RSpec.describe Tag, :type => :model do
  let(:user) { User.create(email: "ajwieme@gmail.com", password: "test_pass") }
  let(:project) { user.projects.create(title: "test project") }
  let(:composition) { user.compositions.create!(title: "first comp", content: "test content", project: project) }
  let(:tag) { user.tags.create(name: "Dumb") }

  context "A tagging" do
    it "Can apply a tag to a text span in a composition" do
      user.tag(tag, composition, 0, 3)
      tagging = user.taggings.first
      expect(tagging.tagable.id).to eq(composition.id)
    end

    it "Can find the tagging content in a composition" do
      user.tag(tag, composition, 0, 3)
      tagging = user.taggings.first
      expect(tagging.get_content).to eq("test")
    end
  end
end
