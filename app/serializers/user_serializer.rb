class UserSerializer < ActiveModel::Serializer
  attributes :unconfirmed_email, :user_id

  def user_id
    object.id
  end

end
