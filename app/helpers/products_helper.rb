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

  def is_present?(model, text , form, attribute,class_name)
    if action_name == 'show'
      model.present? ? text.titleize : "Sem #{text}"
    else
      link_to_add_association "Adicionar #{text}", form, attribute, class: class_name
   end
  end
end
