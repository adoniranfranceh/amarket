module FormHelper
  def icon_number_field(form, attribute, icon_name, options = {})
    input_group_classes = ['input-group', options.delete(:input_group_class)].compact.join(' ')
    content_tag(:div, class: input_group_classes) do
      concat content_tag(:span, content_tag(:i, '', class: "bi bi-#{icon_name}"), class: 'input-group-text')
      concat form.number_field(attribute, options.merge(class: 'form-control input-number mr-4'))
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
