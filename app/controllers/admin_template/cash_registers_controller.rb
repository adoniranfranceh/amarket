class AdminTemplate::CashRegistersController < ApplicationController
  before_action :set_cash

  def create
    @cash_register = @cash.cash_registers.build(cash_register_params)
    @cash_register.opening_time = Time.now
    if @cash_register.save
      open_or_close(true, 'Caixa aberto', 'Não foi possível abrir caixa')
    else
      flash[:error] = 'Existem campos inválidos'
      redirect_to admin_template_cash_index_path
    end
  end

  def update
    @cash_register = CashRegister.find(params[:id])
    if @cash_register.update
      redirect_to admin_template_cash_index_path, notice: 'Caixa atualizado'
    else
      flash[:error] = 'Existem campos inválidos'
      redirect_to redirect_to admin_template_cash_index_path
    end
  end

  def close
    @cash_register = @cash.cash_registers.last
    @cash_register.update(closing_time: Time.now) if @cash_register.present?
    open_or_close(false, 'Caixa fechado', 'Não foi possível fechar caixa')
  end

  private

  def open_or_close(boolean, success_message ,error_message)
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
    params.require(:cash_register).permit(:initial_value, :opening_time, :closing_time)
  end
end
