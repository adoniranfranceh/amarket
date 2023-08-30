module AdminHelper
  def avatar(admin)
    image_tag url_for(admin.image_url), class: 'avatar', value: admin.id
  end

  def avatar_profile(admin)
    image_tag url_for(admin.image_url), class: 'profile_avatar', value: admin.id
  end

  def format_to_decimal(value)
    "R$ #{number_with_precision(value, precision: 2, delimiter: '.', separator: ',')}"
  end
end