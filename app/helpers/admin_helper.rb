module AdminHelper
  def avatar(admin)
    image_tag url_for(admin.image_url), class: 'avatar', value: admin.id
  end

  def avatar_profile(admin)
    image_tag url_for(admin.image_url), class: 'profile_avatar', value: admin.id
  end
end