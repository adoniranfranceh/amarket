module SalesHelper
  def available_payment_methods
    ['Pix', 'Dinheiro' , 'Cartão de Débito', 'Cartão de Crédito', 'Transferência Bancária', 'Outros']
  end

  def available_payment_methods_others
    ['Pix', 'Dinheiro' ,'Cartão de Dédito', 'Cartão de Crédito','Transferência Bancária']
  end

  def pdf_and_devolution_btn(sale)
    return unless sale.status == 'completed'

    pdf_btn = link_to invoice_admin_template_sale_path(sale, format: :pdf), class: 'btn btn-primary mr-1' do
      content_tag(:i, '', class: 'bi bi-card-text')
    end

    devolution_btn = link_to '#', class: 'btn btn-warning admin-action-link', data: { status: 'devolution', sale_id: sale.id } do
      content_tag(:i, '', class: 'bi bi-arrow-counterclockwise')
    end

    pdf_btn + devolution_btn
  end

  def cancel_btn(sale)
    return unless sale.status != 'completed' && sale.status != 'devolution' && sale.status != 'canceled'

    link_to '#', class: 'btn btn-danger admin-action-link', remote: true, data: { status: 'canceled', sale_id: sale.id } do
      content_tag(:i, '', class: 'bi bi-x-lg')
    end
  end

  def select_status(sale)
    return unless sale.status != 'completed' && sale.status != 'canceled' && sale.status != 'devolution'

    modal_id = "statusModal#{sale.id}"
    content_tag(:button, class: 'btn btn-primary', data: { toggle: 'modal', target: "##{modal_id}" }) do
      content_tag(:i, '', class: 'bi bi-arrow-down-up')
    end +
      render('admin_template/shared/status_select_modal', sale: sale, modal_id: modal_id)
  end

  def status(sale)
    "#{sale.updated_at.strftime('%d/%m/%Y %H:%M')}"
  end

  def wrapped_icon(classes)
    content_tag(:span, class: 'circle-icon') do
      content_tag(:i, nil, class: classes)
    end
  end

  def status_icon(status)
    case status
    when 'completed'
      wrapped_icon('bi bi-check-circle-fill text-success')
    when 'pending'
      wrapped_icon('bi bi-hourglass-split text-primary')
    when 'in_progress'
      wrapped_icon('bi bi-gear-wide-connected text-info')
    when 'canceled'
      wrapped_icon('bi bi-x-circle-fill text-danger')
    when 'devolution'
      wrapped_icon('bi bi-arrow-left-circle-fill text-warning')
    else
      wrapped_icon('bi bi-question-circle-fill text-muted')
    end
  end
end
