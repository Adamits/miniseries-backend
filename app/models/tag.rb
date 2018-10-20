class Tag < ActiveRecord::Base
  belongs_to :user
  has_many :taggings, :counter_cache => true
  has_many :votes, as: :votable

  validates :name, presence: :true
  validates :name, uniqueness: true
end
