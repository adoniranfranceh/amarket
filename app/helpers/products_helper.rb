module ProductsHelper
  def category_name
    if @category.nil?
      'Nenhuma'
    else
      @category.name
    end
  end

  def image(product)
    image_tag url_for(product.image_url), class: 'image-t', value: product.id
  end

  def is_present?(model, text , form, attribute,class_name)
    if action_name == 'show'
      model.present? ? text.titleize : "Sem #{text}"
    else
      link_to_add_association "Adicionar #{text}", form, attribute, class: class_name
   end
  end
end
