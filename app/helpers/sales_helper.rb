module SalesHelper
  def available_payment_methods
    ['Pix', 'Dinheiro' , 'Cartão de Débito', 'Cartão de Crédito', 'Transferência Bancária', 'Outros']
  end

  def available_payment_methods_others
    ['Pix', 'Dinheiro' ,'Cartão de Dédito', 'Cartão de Crédito','Transferência Bancária']
  end

  def pdf_and_devolution_btns(sale)
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
end
