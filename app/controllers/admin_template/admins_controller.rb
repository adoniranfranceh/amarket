class AdminTemplate::AdminsController < AdminTemplateController
  before_action :set_admin

  def show; end

  def edit; end

  def update
    if @admin.update(params_admin)
      redirect_to edit_admin_template_admin_path(@admin), notice: 'Atualizado!'
    else
      flash[:error] = 'Não atualizado, verifique os campos'
      render :edit
    end
  end

  def set_admin
    @admin = current_admin
  end

  def edit_password; end

  def update_password
    if @admin.update_with_password(admin_password_params)
      bypass_sign_in(@admin)
      redirect_to edit_admin_template_admin_path(@admin), notice: 'Senha atualizada'
    else
      render :edit_password
    end
  end

  private

  def admin_password_params
    params.require(:admin).permit(:password, :password_confirmation, :current_password)
  end

  def params_admin
    params.require(:admin).permit(:email,
                                  :avatar,
                                   profile_admin_attributes: [:id, :first_name, :last_name])
  end
end
