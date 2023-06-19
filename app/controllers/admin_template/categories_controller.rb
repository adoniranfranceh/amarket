class AdminTemplate::CategoriesController < AdminTemplate::InventaryController
  before_action :set_category, only: [:index, :edit, :update, :show, :destroy]
  def index; end

  def new
    @category = current_admin.categories.build
  end

  def create
    @category = current_admin.categories.build(category_params)
    if @category.save
       redirect_to admin_template_inventary_categories_path, notice: 'Categoria salvo com sucesso'
    else
      render :new
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to admin_template_category_url, notice: 'Categoria atualizado'
    else
      render :edit
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def show;end

  def destroy
    if @category.destroy
      redirect_to admin_template_categories_path, notice: "Categoria #{@category.name} excluído"
    end
  end

  private

  def set_category
    if action_name != 'index'
      @category = Category.find(params[:id])
    end
    @categories = current_admin.categories 
  end

  def category_params
    params.require(:category).permit(:name, :descryption)
  end
end
