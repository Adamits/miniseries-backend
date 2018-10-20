class Project < ActiveRecord::Base
  belongs_to :user
  has_many :compositions, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :title, presence: true
  validates :title, uniqueness: { scope: :user }

  def self.published_compositions
    compositions.published
  end

  def published_compositions_count
    compositions.where(published: true).count
  end

  def most_recently_published_composition
    compositions.where(published: true).order(updated_at: :asc).last
  end

  def next_composition(composition)
    #TODO: replace based on 'order'
    compositions.where(published: true).where(order: self.order + 1)
  end
end
