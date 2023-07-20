class AdminTemplate::ProductsController < AdminTemplate::InventaryController
  before_action :set_product, only: [:index, :edit, :update, :show, :destroy]
  before_action :set_categories, only: [:edit, :new]
  before_action :set_subgroups, only: [:show, :edit]

  def index; end

  def new
    @product = current_admin.products.build
  end

  def create
    @product = current_admin.products.build(product_params)
    if @product.save
       create_secondary_records(@product)
       redirect_to admin_template_products_path, success: 'Produto salvo com sucesso'
    else
      render :new
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      create_secondary_records(@product)
      redirect_to admin_template_product_path(@product), success: 'Produto atualizado'
    else
      render :edit
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def show; end

  def destroy
    @product.secondaryproducts.destroy_all
    if @product.destroy
       @message = "Você quer excluir o produto #{@product.name}"
      redirect_to admin_template_products_path, success: "Produto #{@product.name} excluído"
    end
  end

  def search
    term = params[:term]

    products = Product.where("LOWER(name) LIKE ? OR LOWER(brand) LIKE ?", "%#{term.downcase}%", "%#{term.downcase}%")
    secondaryproducts = Secondaryproduct.where("LOWER(name) LIKE ?", "%#{term.downcase}%")

    search_results = products.or(secondaryproducts)

    products_data = products.map do |product|
      data = {
        id: product.id,
        name: product.name,
        brand: product.brand.present? ? " - #{product.brand}" : "",
        sale_price: product.sale_price,
        quantity: product.quantity
      }
      data[:image_url] = product.image_url
      data
    end

    secondaryproducts_data = secondaryproducts.map do |secondaryproduct|
      data = {
        id: secondaryproduct.id,
        name: secondaryproduct.name,
        brand: "",
        sale_price: secondaryproduct.sale_price,
        quantity: secondaryproduct.quantity
      }
      data[:image_url] = secondaryproduct.image_url
      data
    end

    all_results = products_data + secondaryproducts_data

    render json: all_results
  end

  private

  def set_categories
    @categories = current_admin.categories
  end

  def set_subgroups
    @subgroups = @product.variations.flat_map(&:subgroups)
  end

  def set_product
    if action_name != 'index'
      @product = Product.find(params[:id])
      @category = @product.category
    end
    @products = current_admin.products
  end

  def product_params
     params.require(:product).permit(
                                      :name,
                                      :descryption,
                                      :category_id,
                                      :brand,
                                      :purchase_price,
                                      :sale_price,
                                      :quantity,
                                      :image,
                                      variations_attributes: [
                                        :id,
                                        :name,
                                        :variation_type,
                                        :color,
                                        :photo,
                                        :variation_quantity,
                                        :_destroy,
                                        subgroups_attributes: [
                                          :id,
                                          :size,
                                          :number,
                                          :quantity,
                                          :_destroy
                                        ]
                                      ]
                                    )
  end

  def create_secondary_records(product)
    Secondaryproduct.destroy_all
    if product.variations.present?
      product.variations.each do |variation|
        secondary_name = "#{product.full_name} #{variation.name} - #{variation.variation_type} - #{variation.color}"
        secondary = Secondaryproduct.find_or_initialize_by(
                                            admin_id: product.admin_id,
                                            product_id: product.id,
                                            name: "#{secondary_name}"
                                          )

        if variation.subgroups.present?
          variation.subgroups.each do |subgroup|
            subgroup_secondary_name = "#{product.full_name} #{variation.name} - #{variation.variation_type} - #{variation.color} - #{subgroup.size}"
            subgroup_secondary = Secondaryproduct.find_or_initialize_by(
                                                             admin_id: product.admin_id,
                                                             product_id: product.id,
                                                             name: "#{subgroup_secondary_name}"
                                                           )
            subgroup_secondary.update(
                                      quantity: subgroup.quantity,
                                      image: variation.photo.blob,
                                      sale_price: product.sale_price,
                                      purchase_price: product.purchase_price
                                      )
            subgroup_secondary.save
            next
          end
        else
          secondary.update(
                           quantity: variation.variation_quantity,
                           image: variation.photo.blob,
                           sale_price: product.sale_price,
                           purchase_price: product.purchase_price
                           )
        end
      end
    end
  end
end
