class AdminTemplate::CashRegistersController < AdminTemplateController
  before_action :set_cash
  include CashRegisterable
  include NumberUtils

  def create
    @cash_register = @cash.cash_registers.build(cash_register_params)
    @cash_register.opening_time = Time.now
    @cash_register.cash_sale = 0
    format_decimal_value_movement
    @cash_register.cash_total = params[:cash_register][:initial_value]

    if @cash_register.save
      @current_cash_register = @cash_register
      open_or_close(true, 'Caixa aberto', 'Não foi possível abrir caixa')
    else
      flash[:error] = 'Existem campos inválidos'
      redirect_to admin_template_cash_index_path
    end
  end

  def close
    @cash_register = current_cash_register
    @cash_register.update(closing_time: Time.now)
    open_or_close(false, 'Caixa fechado', 'Não foi possível fechar caixa')
  end

  private

  def format_decimal_value_movement
    if params[:cash_register][:initial_value].present?
      format_decimal_value(params[:cash_register], "initial_value")
      @cash_register.initial_value = params[:cash_register][:initial_value]
    end
  end

  def open_or_close(boolean, success_message, error_message)
    if @cash.update(is_open: boolean)
      redirect_to admin_template_cash_index_path, notice: success_message
    else
      flash[:error] = error_message
      redirect_to admin_template_cash_index_path
    end
  end

  def set_cash
    @cash = Cash.find_by(admin_id: current_admin.id)
  end

  def cash_register_params
    params.require(:cash_register).permit(:initial_value)
  end
end
