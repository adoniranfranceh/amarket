module ProductsHelper
  def category_name
    if @category.nil?
      'Nenhuma'
    else
      @category.name
    end
  end

  def image(product)
    if product.image.attached?
      image_tag url_for(product.image), class: 'image-t', value: product.id
    else
      image_tag('no_image.png',  class: 'image-t no_image', value: product.id)
    end
  end
end
