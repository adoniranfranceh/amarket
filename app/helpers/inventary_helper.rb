module InventaryHelper
  def url_new_edit
    if params[:controller] == 'admin_template/inventary/products'
      action_name == 'new' ? admin_template_inventary_products_path : admin_template_inventary_product_path
    else
      action_name == 'new' ? admin_template_inventary_categories_path : admin_template_inventary_category_path
    end
  end
end
