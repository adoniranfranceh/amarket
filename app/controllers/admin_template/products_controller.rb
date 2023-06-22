class AdminTemplate::ProductsController < AdminTemplate::InventaryController
  before_action :set_product, only: [:index, :edit, :update, :show, :destroy]
  before_action :set_categories, only: [:edit, :new]

  def index; end

  def new
    @product = current_admin.products.build
  end

  def create
    @product = current_admin.products.build(product_params)
    if @product.save
       redirect_to admin_template_products_path, notice: 'Categoria salvo com sucesso'
    else
      render :new
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to admin_template_products_path, notice: 'Categoria atualizado'
    else
      render :edit
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def show;end

  def destroy
    if @product.destroy
      redirect_to admin_template_products_path, notice: "Categoria #{@product.name} excluído"
    end
  end

  def search
    term = params[:term]

    products = Product.where("LOWER(name) LIKE ?", "%#{term}%")


    render json: products
  end

  private

  def set_categories
    @categories = current_admin.categories
  end

  def set_product
    if action_name != 'index'
      @product = Product.find(params[:id])
      @category = @product.category
    end
    @products = current_admin.products
  end

  def product_params
    params.require(:product).permit(:name,
                                    :descryption,
                                    :category_id,
                                    :brand,
                                    :purchase_price,
                                    :sale_price,
                                    :quantity
                                    )
  end
end