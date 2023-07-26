module ApplicationHelper
  def fieldset_disabled
    if action_name == 'show'
      'disabled-form'
    end
  end

  def image(product)
    image_tag url_for(product.image_url), class: 'image-t', value: product.id
  end
end
