class Security::RoleProfilesController < ApplicationController
  before_action :set_security_role_profile, only: [:show, :edit, :update, :destroy]


  # GET /security/role_profiles
  # GET /security/role_profiles.json
  def index
    @security_role_profiles = Security::RoleProfile.all
  end

  # GET /security/role_profiles/1
  # GET /security/role_profiles/1.json
  def show
  end

  # GET /security/role_profiles/new
  def new 
  end

  # GET /security/role_profiles/1/edit
  def edit
   
  end

  # POST /security/role_profiles
  # POST /security/role_profiles.json
  def create
    @role_profile = Security::RoleProfile.new(security_role_profile_params)
    unless $profile.nil?
      @profile = $profile
    else
      @profile = Security::Profile.last
    end
    
    unless @profile.nil?
      @role_profile.security_profile_id = @profile.id
    end
    @role_profile.user_created_id = current_user.id
    respond_to do |format|
        if @role_profile.save
          format.html { redirect_to @role_profile, notice: 'Se creó con éxito el rol para este perfil.' }
          format.json { render :show, status: :created, location: @role_profile }
          format.js   { render 'security/role_profiles/create.js.erb' }
        else
          format.html { render :new }
          format.json { render json: @role_profile.errors, status: :unprocessable_entity }
          format.js { render json: @role_profile.errors, status: :unprocessable_entity }

        end
      end 
  end


  # PATCH/PUT /security/role_profiles/1
  # PATCH/PUT /security/role_profiles/1.json
  def update
    @security_role_profile.user_updated_id = current_user.id
    respond_to do |format|
      if @security_role_profile.update(security_role_profile_params)
        format.html { redirect_to @security_role_profile, notice: 'Se actualizó con éxito el rol para este perfil.' }
        format.json { render :show, status: :ok, location: @security_role_profile }
      else
        format.html { render :edit }
        format.json { render json: @security_role_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /security/role_profiles/1
  # DELETE /security/role_profiles/1.json
  def destroy
    @idProfile= @security_role_profile.security_profile_id
    @security_role_profile.destroy
    respond_to do |format|
      format.html { redirect_to security_profile_url(@idProfile), notice: 'Se eliminó con éxito este rol para este perfil.' }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_security_role_profile
      @security_role_profile = Security::RoleProfile.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def security_role_profile_params
      params.require(:security_role_profile).permit(:security_profile_id, :security_role_id, :start_date, :end_date, :security_role_type_id)
    end


end
