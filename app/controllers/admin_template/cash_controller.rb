class AdminTemplate::CashController < AdminTemplateController
   before_action :set_cash_register, only: [:index, :edit, :update]
   include CashRegisterable
  def index
    @admin = current_admin
  end

  def update
    if @cash.update(cash_register_params)
      redirect_to admin_template_cash_registers_path, notice: 'Caixa atualizado'
    else
      flash[:error] = 'Existem campos inválidos'
      render :edit
    end
  end

  def set_cash_register
    @cash = current_admin.cash.find_by(admin_id: current_admin.id)
    if @cash.cash_registers.present?
      @cash_register = current_cash_register
      @movement = @cash_register.movements.build if @cash_register.present?
    end
  end

  private 

  def cash_register_params
    params.require(:cash_register).permit(
                                          :cash_name,
                                          :open?
                                          )
  end
end
