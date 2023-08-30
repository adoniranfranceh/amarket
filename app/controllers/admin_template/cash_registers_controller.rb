class AdminTemplate::CashRegistersController < AdminTemplateController
  before_action :set_cash
  include CashRegisterable
  include NumberUtils
  include DecimalCoin

  def index
    @date = params[:start_date].present? ? Date.parse(params[:start_date]) : Date.today
    if params[:show_all] == 'true'
      @cash_registers = current_admin.cash.last.cash_registers.order(created_at: :desc).page(params[:page]).per(5)
    else
      @cash_registers = current_admin.cash.last.cash_registers.within_date_range(@date).order(created_at: :desc).page(params[:page]).per(5)
    end
    @movements = Movement.where(cash_register_id: @cash_registers.pluck(:id)).page(params[:page]).per(2)
  end


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

  def close_if_last_day
    if current_cash_register && current_cash_register.opening_time.to_day < Date.current
      current_cash_register.update(closing_time: current_cash_register.opening_time.end_of_day)
      flash[:notice] = 'Caixa fechado automaticamente.'
    end
  end

  def show_cash_register
    @cash_register = CashRegister.find(params[:id])
    @movements = @cash_register.movements

    respond_to do |format|
      format.html { render body: nil } # Adicione esta linha para o formato HTML
      format.pdf do
        if @cash_register.closing_time.present?
          pdf = generate_pdf(@cash_register, @movements, current_admin,)
          pdf_filename = "nota_de_caixa_#{@cash_register.id}_#{Time.now.strftime('%Y%m%d%H%M%S')}.pdf"
          send_data pdf, filename: pdf_filename, type: 'application/pdf', disposition: 'inline'
        else
          flash[:error] = 'A nota fiscal do caixa só pode ser gerada quando o caixa está fechado.'
          redirect_to admin_template_cash_index_path
        end
      end
    end
  end

  private

  def generate_pdf(register, items, admin)
    pdf = Prawn::Document.new(page_size: 'A7', margin: [10, 10, 10, 10], info: {
      Title: "Registro - Caixa #{register.id}",
      Author: "#{admin.full_name_admin}",
      Subject: "Nota",
      Creator: "AMarket"
    })
    line = '_______________________________'

    pdf.font_size 11

    pdf.text "#{admin.full_name_admin}", align: :center, style: :bold, size: 11
    pdf.text line
    pdf.text '**** FECHAMENTO DE CAIXA ****', align: :center, size: 11
    pdf.text line

    pdf.text "ABERTURA............: #{register.opening_time.strftime('%d/%m/%Y %H:%M')}"
    pdf.text "FECHAMENTO......: #{register.closing_time.strftime('%d/%m/%Y %H:%M')}"
    pdf.text line

    pdf.text 'TOTAL DE VENDAS (R$):'
    pdf.text "(+)VENDAS   #{format_to_decimal(register.cash_sale)}"
    pdf.text "(=)SUBTOTAL   #{format_to_decimal(register.cash_total)}"
    pdf.text line

    pdf.text 'ENTRADA (R$)'
    pdf.text "(+) FUNDO INICIAL #{format_to_decimal(register.initial_value)}"
    pdf.text "(+) SUPRIMENTO #{format_to_decimal(items.sum(:cash_deposit))}"
    pdf.text line

    pdf.text 'SANGRIA'
    pdf.text "(-) DINHEIRO #{format_to_decimal(items.sum(:cash_withdrawal))}"
    pdf.text line

    pdf.text 'FIM', align: :center

    pdf.render
  end

  def format_decimal_value_movement
    if params[:cash_register][:initial_value].present?
      format_decimal_value(params[:cash_register], "initial_value")
      @cash_register.initial_value = params[:cash_register][:initial_value]
    end
  end

  def open_or_close(boolean, success_message, error_message)
    if @cash.update(is_open: boolean)
      redirect_to admin_template_cash_index_path, notice: success_message
      generate_pdf(@cash_register) unless boolean
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
