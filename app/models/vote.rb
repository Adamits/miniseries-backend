class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :votable_type, :votable_id, :user_id, presence: true

  def valid_vote_types
    ["Vote::PositiveVote", "Vote::NegativeVote"]
  end

  def name_as_string
    name || "Vote"
  end

  def can_be_cast_by?(user, votable)
    true
  end
end
