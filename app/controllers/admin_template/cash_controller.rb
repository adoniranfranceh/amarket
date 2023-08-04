class AdminTemplate::CashController < AdminTemplateController
   before_action :set_cash_register, only: [:index, :edit, :update]

  def index; end

  def update
    if @cash.update(cash_register_params)
      redirect_to admin_template_cash_registers_path, notice: 'Caixa atualizado'
    else
      flash[:error] = 'Existem campos inválidos'
      render :edit
    end
  end

  def set_cash_register
    @cash = Cash.where(admin_id: current_admin.id).first
  end

  private 

  def cash_register_params
    params.require(:cash_register).permit(
                                          :cash_name,
                                          :open?
                                          )
  end
end