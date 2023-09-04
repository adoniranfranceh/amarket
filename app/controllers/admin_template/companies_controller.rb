class AdminTemplate::CompaniesController < AdminTemplateController
  before_action :set_company, only: [:show, :edit, :update]
  def new
    @company = current_admin.build_company
  end

  def create
    @company = current_admin.build_company(paramns_company)
    if @company.save
      redirect_to admin_template_company_path(@company), notice: 'Empresa registrada com sucesso!'
    else 
      flash[:error] = 'Houve algum erro ao tentar registrar empresa'
      render :new
    end
  end

  def show; end

  def edit; end

  def update
    if @company.update(paramns_company)
      redirect_to admin_template_company_path, notice: 'Empresa atualizada com sucesso!'
    else
      render :edit
      flash[:error] = 'Houve algum erro ao tentar atualizar empresa'
    end
  end

  def set_company
     @company = Company.find(params[:id])
  end

  def paramns_company
    params.require(:company).permit(:name, :cnpj, :logo)
  end
end
