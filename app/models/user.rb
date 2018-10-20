class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects, dependent: :destroy
  has_many :compositions
  has_many :votes, dependent: :destroy
  has_many :tags
  has_many :taggings

  def cast_vote(vote_type, votable)
    if can_cast_vote_type_on?(vote_type, votable)
      vote = vote_type.constantize.new
      vote.user = self
      vote.votable = votable
      vote.save
    else
      errors.add(:base, "You do not have permission to vote on this!")
      false
    end
  end

  def tag(tag, tagable, start_span, end_span, content=nil)
    if can_tag_with?(tag, tagable)
      tagging = self.taggings.new
      tagging.tagable = tagable
      tagging.tag = tag
      tagging.start = start_span
      tagging.end = end_span
      tagging.content = content
      tagging.save
    else
      errors.add(:base, "You do not have permission to tag this!")
      false
    end
  end

  def can_cast_vote_type_on?(vote_type, votable)
    vote_type.constantize.can_be_cast_by?(self, votable) && !has_voted_on?(votable)
  end

  def has_voted_on?(votable)
    votes.where(votable: votable).any?
  end

  def can_tag_with?(tag, tagable)
    tagable.can_be_tagged_by?(self, tag)
  end
end
