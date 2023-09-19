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
end
