module MediaHelper
  def in_favorites_list(media, user)
    return false unless media && user
    FavoriteMedium.find_by(media_number: media.number, user_id: user.id)
  end
end