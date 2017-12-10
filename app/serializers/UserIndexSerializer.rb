class UserIndexSerializer < ActiveModel::Serializer
    attributes :id, :name, :email
end