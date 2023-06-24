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
      image_tag url_for(product.image), class: 'image-t'
    else
      form_with(model: product, url: admin_template_products_path) do |form|
        form.file_field :image
      end
    end
  end
end
