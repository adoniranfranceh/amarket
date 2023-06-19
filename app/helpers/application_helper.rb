module ApplicationHelper
  def url_new_edit
    case params[:controller]
      when 'admin_template/products'
        action_name == 'new' ? admin_template_products_path : admin_template_product_path
      when 'admin_template/categories'
        action_name == 'new' ? admin_template_inventary_categories_path : admin_template_inventary_category_path
      when 'admin_template/customers'
        action_name == 'new' ? admin_template_customers_path : admin_template_customer_path
    end
  end
end
