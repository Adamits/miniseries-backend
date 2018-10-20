class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :compositions_count, :projects, :compositions
end
