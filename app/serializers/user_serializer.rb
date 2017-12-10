class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :issues_created
  def issues_created
      Issue.where(user_id: object.id)
  end
end