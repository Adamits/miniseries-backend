class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag, :counter_cache => true
  belongs_to :tagable, polymorphic: :true, :counter_cache => true
  has_many :votes, as: :votable

  validates :start, :end, presence: :true

  def get_content
    content || tagable.content[self.start..self.end]
  end
end
