class AdminTemplate::ProductsController < AdminTemplate::InventaryController
  before_action :set_product, only: [:index, :edit, :update, :show, :destroy]
  before_action :set_categories, only: [:edit, :new]
  before_action :set_subgroups, only: [:show]

  def index; end

  def new
    @product = current_admin.products.build
  end

  def create
    @product = current_admin.products.build(product_params)
    if @product.save
       redirect_to admin_template_products_path, notice: 'Produto salvo com sucesso'
    else
      render :new
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to admin_template_product_path(@product), notice: 'Produto atualizado'
    else
      render :edit
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def show; end

  def destroy
    if @product.destroy
      redirect_to admin_template_products_path, notice: "Produto #{@product.name} excluído"
    end
  end

  def search
    term = params[:term]

    products = Product.where("LOWER(name) LIKE ? OR LOWER(brand) LIKE ?", "%#{term.downcase}%", "%#{term.downcase}%")

    products_data = products.map do |product|
      variations = product.variations.map do |variation|
        subgroups = variation.subgroups.map do |subgroup|
          {
            size: subgroup.size,
            number: subgroup.number,
            quantity: subgroup.quantity
          }
        end

        {
          id: variation.id,
          name: variation.name,
          color: variation.color,
          photo: variation.image_url,
          subgroups: subgroups
        }
      end

      data = {
        id: product.id,
        name: product.name,
        brand: product.brand,
        sale_price: product.sale_price,
        quantity: product.quantity,
        variations: variations
      }

      data[:image_url] = product.image_url
      data
    end

    render json: products_data
  end

  private

  def set_categories
    @categories = current_admin.categories
  end

  def set_subgroups
    @product.variations.each do |variation|
      @subgroups = variation.subgroups
    end
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
end
