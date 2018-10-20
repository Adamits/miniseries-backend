class CompositionSerializer < ActiveModel::Serializer
  attributes :id, :title, :content, :description, :published, :order, :taggings_count,
            :user, :project, :created_at, :updated_at, :taggings, :tags
end
