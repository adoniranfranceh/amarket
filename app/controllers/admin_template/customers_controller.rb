class AdminTemplate::CustomersController < AdminTemplateController
  def index
    @customers = Customer.all
  end

  def new
    @customer = current_admin.customers.build
  end

  def create
    @customer = current_admin.customers.build(customer_params)
    if @customer.save
       redirect_to admin_template_customers_path, notice: 'Cliente salvo com sucesso'
    else
      render :new
      flash[:error] = 'Existem campos inválidos'
    end
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
                                     :cpf
                                     )
  end
end