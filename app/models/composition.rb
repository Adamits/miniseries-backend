class Composition < ActiveRecord::Base
  belongs_to :user, :counter_cache => true
  belongs_to :project, :counter_cache => true
  has_many :taggings, as: :tagable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  after_create :set_order

  validates :title, :content, :user, presence: :true
  validates :title, uniqueness: { scope: :project }

  def self.published
    where(published: true)
  end

  def tags
    tag_ids = taggings.pluck(:tag_id).uniq
    Tag.where(id: tag_ids)
  end

  def next
    project.next_composition(self)
  end

  def publish
    self.published = true
    self.save
  end

  def positive_votes
    votes.where(type: "Vote::Positive")
  end

  def negative_votes
    votes.where(type: "Vote::Negative")
  end

  def can_be_tagged_by?(tagger, tag)
    true
  end

  private
  def set_order
    if not order
      self.order = (Composition.maximum("order") || -1) + 1
      self.save
    end
  end
end
