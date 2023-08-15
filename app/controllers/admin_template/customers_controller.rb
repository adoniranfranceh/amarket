class AdminTemplate::CustomersController < AdminTemplateController
  before_action :set_customer, only: [:index, :edit, :update, :show, :destroy]

  def index; end

  def new
    @customer =  current_admin.customers.build
  end

  def create
    @customer =  current_admin.customers.build(customer_params)
    if @customer.save
       redirect_to admin_template_customers_path, notice: 'Cliente salvo com sucesso'
    else
      render :new
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def edit; end

  def update
    if @customer.update(customer_params)
      redirect_to admin_template_customer_url, notice: 'Cliente atualizado'
    else
      render :edit
      flash[:error] = 'Existem campos inválidos'
    end
  end

  def show;end

  def destroy
    if @customer.destroy
      redirect_to admin_template_customers_path, notice: "Cliente #{@customer.name} excluído"
    end
  end

  def search
    @customers = Customer.where("name LIKE ?", "%#{params[:term]}%")
    render json: @customers.map { |c| { id: c.id, text: c.name } }
  end

  private

  def customer_params
    params.require(:customer).permit(:name,
                                     :phone,
                                     :email,
                                     :city,
                                     :neighborhood,
                                     :andress,
                                     :house_number,
                                     :cpf)
  end

  def set_customer
    if action_name != 'index'
      @customer = Customer.find(params[:id])
    end
    @customers = current_admin.customers
  end
end
