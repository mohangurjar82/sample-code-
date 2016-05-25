class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :name, :avatar_url, :authentication_token

end