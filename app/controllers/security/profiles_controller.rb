class Security::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :verificar_permiso
  before_action :crear
  before_action :modificar
  before_action :eliminar
  before_action :consultar
  before_action :activar
  before_action :set_security_profile, only: [:show, :edit, :update, :destroy, :habilitar, :inhabilitar, :motive]
  before_action :title
  before_action :eliminarVariableGlobales, only: [:new]
  # GET /security/profiles
  # GET /security/profiles.json

  def index
    respond_to do |format|
      if params[:search]
        format.html { @security_profiles = Security::Profile.search(params[:search]).order("created_at DESC")}
        format.json { @security_profiles = Security::Profile.search(params[:search]).order("created_at DESC")}
      else
        format.html { @security_profiles = Security::Profile.all.order('created_at DESC')}
        format.json { @security_profiles = Security::Profile.all.order('created_at DESC')}
      end
    end
  end

  def motive
    
  end

  # GET /security/profiles/1
  # GET /security/profiles/1.json
  def show
   @motives_profile = MotiveProfile.where(profile_id: params[:id]).order("created_at DESC")  
   @role_profiles = Security::RoleProfile.where(security_profile_id: params[:id])
  end

  # GET /security/profiles/new
  def new
    @security_profile = Security::Profile.new
    @security_roles = Security::Role.all
    @security_role_types = Security::RoleType.all
    @security_role_profile = Security::RoleProfile.new
  end

  # GET /security/profiles/1/edit
  def edit
    @security_role_profile = Security::RoleProfile.new
    @role_profiles = Security::RoleProfile.where(security_profile_id: params[:id])
    @security_roles= Security::Role.all
    @security_role_types= Security::RoleType.all
    $profile =Security::Profile.find(params[:id])
  end

  # POST /security/profiles
  # POST /security/profiles.json
  def create
    @security_profile = Security::Profile.new(security_profile_params)
    @security_profile.user_created_id = current_user.id
    respond_to do |format|
      if @security_profile.save
        format.html { redirect_to security_profiles_path, notice: I18n.t('profiles.controller.create')}
        format.json { render :show, status: :created, location: @security_profile }
      else
        format.html { render :new }
        format.json { render json: @security_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /security/profiles/1
  # PATCH/PUT /security/profiles/1.json
  def update
    @security_profile.user_updated_id = current_user.id
    respond_to do |format|
      if @security_profile.update(security_profile_params)
        format.html { redirect_to security_profiles_path, notice: I18n.t('profiles.controller.update') }
        format.json { render :show, status: :ok, location: @security_profile }
      else
        format.html { render :edit }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

   def habilitar
    if @security_profile.habilitar!
      @security_profile.update(:user_updated_id => current_user.id)
      respond_to do |format|
        format.html { redirect_to security_profiles_path, notice: I18n.t('profiles.controller.enable')}
        format.json { head :no_content }
      end
    end
  end

  #Eliminar Logico
  def inhabilitar
    @security_profile.motive = params[:motive]
    @employees = Employee.find_by(security_profiles_id: @security_profile.id)
    unless params[:motive].empty?
      if @employees.nil?
        @security_profile.user = current_user.id
        if @security_profile.inhabilitar!
          @security_profile.update(:user_updated_id => current_user.id)
          redirect_to security_profiles_path, notice: I18n.t('profiles.controller.disable')
        end
      else
        flash[:errors] = I18n.t('general.action.response.profile.asigned_employee')
        redirect_to "/security/profiles/#{@security_profile.id}/motive"
      end
    else
      flash[:errors] = I18n.t('general.action.response.profile.disable_profile')
      redirect_to "/security/profiles/#{@security_profile.id}/motive"    
    end    
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_security_profile
      @security_profile = Security::Profile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def security_profile_params
      params.require(:security_profile).permit(
        :name,
        :user_created_id,
        :user_updated_id,
        :security_role_id
      )
    end

    def title
      @titulobanner =  I18n.t ('.general.models.profiles')
    end

    def eliminarVariableGlobales
      $profile =nil
    end

end
