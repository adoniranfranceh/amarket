class AdminTemplate::ProductsController < AdminTemplate::InventaryController
  before_action :set_product, only: [:index, :edit, :update, :show, :destroy]
  before_action :set_categories, only: [:edit, :new]
  before_action :set_subgroups, only: [:show, :edit]
  include NumberUtils

  def index; end

  def new
    @product = current_admin.products.build
  end

  def create
    @product = current_admin.products.build(product_params)
    format_decimal_value_product

    respond_to do |format|
      if @product.save
        create_secondary_records(@product)
        format.html { redirect_to admin_template_products_path, notice: 'Produto salvo com sucesso!' }
        format.json { render json: @product, status: :created }
      else
        puts @product.errors.full_messages
        format.html { render :index, flash[:error] = 'Existem campos inválidos' }
        format.json { render json: { errors: @product.errors.full_messages }, status: 422 }
      end
    end
  end

  def edit; end

  def update
    format_decimal_value_product
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

    secondaryproducts = current_admin.secondaryproducts.where("LOWER(name) LIKE ?", "%#{term.downcase}%")

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

    all_results = secondaryproducts_data

    render json: all_results
  end

  private

  def format_decimal_value_product
    if params[:product][:purchase_price].present?
      format_decimal_value(params[:product], "purchase_price")
      @product.purchase_price = params[:product][:purchase_price]
    end
    if params[:product][:sale_price].present?
      format_decimal_value(params[:product], "sale_price")
      @product.sale_price = params[:product][:sale_price]
    end
  end

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
    @products = current_admin.products.includes(:variations,
                                                :image_attachment,
                                                :secondaryproducts,
                                                variations: [:subgroups]
                                                )
                                                .order(:name)
                                                .search(params[:search])
                                                .page(params[:page]).per(5)
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
    Secondaryproduct.transaction do
      Secondaryproduct.where(product_id: product.id).destroy_all
      product.variations.each do |variation|
        variation_name = variation.name.present? ? "- #{variation.name}" : ""
        variation_type = variation.variation_type.present? ? "- #{variation.variation_type}" : ""
        variation_color = variation.color.present? ? "- #{variation.color}" : ""
        if variation.subgroups.present?
          variation.subgroups.each do |subgroup|
            subgroup_size = subgroup.size.present? ? "- #{subgroup.size}" : ""
            subgroup_number = subgroup.number.present? ? "- #{subgroup.number}" : ""
            subgroup_secondary_name = "#{product.full_name} #{variation_name} #{variation_type} #{variation_color} #{subgroup_size} #{subgroup_number}"
            secondary_attributes(
                                 product,
                                 subgroup_secondary_name,
                                 subgroup.quantity,
                                 variation.id,
                                 subgroup.id
                                 )
          end
        else
          secondary_name = "#{product.full_name} #{variation_name} #{variation_type} #{variation_color}"
          secondary_attributes(
                               product, secondary_name,
                               variation.variation_quantity,
                                variation.id
                                )
        end
      end

      if product.variations.blank?
        secondary_product = "#{product.full_name}"
        secondary_attributes(
                             product,
                             secondary_product,
                             product.quantity
                             )
      end
    end
  end

  def secondary_attributes(product, name, quantity, variation = nil, subgroup = nil)
    secondary = Secondaryproduct.find_or_initialize_by(
      admin_id: product.admin_id,
      product_id: product.id,
      name: name
    )
    secondary.update(
      quantity: quantity,
      sale_price: product.sale_price,
      purchase_price: product.purchase_price,
      variation_id: variation,
      subgroup_id: subgroup
    )
  end
end
