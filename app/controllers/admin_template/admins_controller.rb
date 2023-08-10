class AdminTemplate::AdminsController < AdminTemplateController
  before_action :set_admin
  def edit; end

  def update
    if @admin.update(params_admin)
      redirect_to edit_admin_template_admin_path(@admin), notice: 'Atualizado!'
    else
      flash[:error] = 'Não atualizado'
      render :edit
    end
  end

  def set_admin
    @admin = current_admin
  end

  private

  def params_admin
    params.require(:admin).permit(:email,
                                  :password,
                                  :password_confirmation,
                                   profile_admins_attributes: [:id, :first_name, :last_name])
  end
end