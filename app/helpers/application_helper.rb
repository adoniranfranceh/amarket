module ApplicationHelper
  def fieldset_disabled
    if action_name == 'show'
      'disabled-form'
    end
  end

  def image(product)
    image_tag url_for(product.image_url), class: 'image-t', value: product.id
  end

  def dynamic_path_of_the_company(admin)
    if admin.company.try(:persited)
      admin_template_company_path(admin.company)
    else
      new_admin_template_company_path
    end
  end

  def company_icon
    if current_admin.company.try(:persisted?)
      i_class = 'bi bi-building'
      span_content = ' Sua empresa'
    else
      i_class = 'bi bi-building-add'
      span_content = ' Registre sua empresa'
    end

    content_tag(:span, content_tag(:i, '', class: i_class) + span_content)
  end
end
