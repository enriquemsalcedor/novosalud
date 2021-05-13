class OrganizationsController < ApplicationController
  before_action :title
  before_action :set_organization, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :modificar
  #before_action :consultar
  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    @organization.user_updated_id = current_user.id
    respond_to do |format|
      if @organization.update(organization_params)
        format.html { redirect_to @organization, notice: 'Información actualizada satisfactoriamente.' }
        format.json { render :show, status: :ok, location: @organization }
      else
        format.html { render :edit }
        format.json { render json: @organization.errors, status: :unprocessable_entity }
      end
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.organization')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.require(:organization).permit(
        :name,
        :rif,
        :email,
        :address,
        :phone,
        :user_updated_id
      )
    end
end
