class AdminTemplate::MovementsController < AdminTemplateController
  before_action :set_cash_register
  include CashRegisterable
  include NumberUtils

  def create
    @movement = @cash_register.movements.build(movement_params)

    format_decimal_value_movement
    
    unless @movement.cash_deposit.present? || @movement.cash_withdrawal.present?
      flash.now[:error] = "Você deve fornecer um valor para depósito ou sangria de caixa"
      redirect_to admin_template_cash_index_path
    end

    if @movement.save
      redirect_to admin_template_cash_index_path, notice: 'Caixa atualizado'
    else
      flash[:error] = 'Existem campos inválidos'
      redirect_to admin_template_cash_index_path
    end
  end

  private

  def format_decimal_value_movement
    format_decimal_value(:movement, :cash_deposit)
    format_decimal_value(:movement, :cash_withdrawal)
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
