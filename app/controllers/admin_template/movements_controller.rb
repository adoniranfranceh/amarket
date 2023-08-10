class AdminTemplate::MovementsController < AdminTemplateController
  before_action :set_cash_register
  before_action :smaller_than_0, only: [:create]
  include CashRegisterable
  include NumberUtils

  def create
    @movement = @cash_register.movements.build(movement_params)
    format_decimal_value_movement
    
    if !@movement.cash_deposit.present? && !@movement.cash_withdrawal.present?
      flash[:error] = "Você deve fornecer um valor para depósito ou sangria de caixa"
      redirect_to admin_template_cash_index_path
    elsif @movement.save
      redirect_to admin_template_cash_index_path, notice: 'Caixa atualizado'
    else
      flash[:error] = 'Existem campos inválidos'
      redirect_to admin_template_cash_index_path
    end
  end

  private

  def smaller_than_0
    if @cash_register.cash_total < params[:movement][:cash_withdrawal].to_f
      needed_value = params[:movement][:cash_withdrawal].to_f - current_cash_register.cash_total
      flash[:error] = "Saldo insuficiente para ser retirado. Faltou #{needed_value}"
      redirect_to admin_template_cash_index_path
    end
  end

  def format_decimal_value_movement
    if params[:movement][:cash_deposit].present?
      format_decimal_value(params[:movement], "cash_deposit")
       @movement.cash_deposit = params[:movement][:cash_deposit]
    elsif params[:movement][:cash_withdrawal].present?
      format_decimal_value(params[:movement], "cash_withdrawal")
      @movement.cash_withdrawal = params[:movement][:cash_withdrawal]
    end
  end

  def set_cash_register
    @cash_register = current_cash_register
  end

  def movement_params
    params.require(:movement).permit(
      :cash_withdrawal,
      :cash_deposit,
      :reason
    )
  end
end
