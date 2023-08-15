module ProductsHelper
  def category_name
    if @category.nil?
      'Nenhuma'
    else
      @category.name
    end
  end

  def is_present?(model, text , form, attribute,class_name)
    if action_name == 'show'
      model.present? ? text.titleize : "Sem #{text}"
    else
      link_to_add_association "Adicionar #{text}", form, attribute, class: class_name
   end
  end

  def investment
    @products.sum { |product| product.purchase_price.to_f * product.quantity.to_f }
  end

  def profit
    @products.sum { |product| product.sale_price.to_f * product.quantity.to_f }
  end
end
