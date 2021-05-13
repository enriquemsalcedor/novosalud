class BeneficiariesController < ApplicationController
  before_action :title
  before_action :set_beneficiary, only: [:show, :edit, :update, :destroy, :habilitar,
  :inhabilitar]
  before_action :authenticate_user!

  # GET /beneficiaries
  # GET /beneficiaries.json
  def index
    respond_to do |format|
      if params[:search]
        format.html { @beneficiaries = Beneficiary.search(params[:search]).order("created_at DESC")}
        format.json { @beneficiaries = Beneficiary.search(params[:search]).order("created_at DESC")}
      else
        format.html { @beneficiaries = Beneficiary.all.order('created_at DESC')}
        format.json { @beneficiaries = Beneficiary.all.order('created_at DESC')}
      end
    end
  end

  # GET /beneficiaries/1
  # GET /beneficiaries/1.json
  def show
  end

  # GET /beneficiaries/new
  def new
    @beneficiary = Beneficiary.new
    @beneficiary.build_people
  end

  # GET /beneficiaries/1/edit
  def edit
    @people = People.find_by id: @beneficiary.people_id
  end

  # POST /beneficiaries
  # POST /beneficiaries.json
  def create
    @beneficiary = Beneficiary.new(beneficiary_params)
    @beneficiary.user_created_id = current_user.id
    inicializar_attr_accessor
    respond_to do |format|
      if @beneficiary.save
        format.html { redirect_to @beneficiary, notice: I18n.t('.beneficiaries.controller.create')  }
        format.js { render "beneficiaries/close.js.erb"}
      else
        format.html { render :new }
        format.json { render json: @beneficiary.errors, status: :unprocessable_entity }
        format.js { render "beneficiaries/errors.js.erb"}
      end
    end
  end

  # PATCH/PUT /beneficiaries/1
  # PATCH/PUT /beneficiaries/1.json
  def update
    @beneficiary.user_updated_id = current_user.id
    inicializar_attr_accessor
    respond_to do |format|
      if @beneficiary.update_attributes(beneficiary_params)

        format.html { redirect_to @beneficiary, notice: I18n.t('beneficiaries.controller.update')  }
        format.json { render :show, status: :ok, location: @beneficiary }
      else
        format.html { render :edit }
        format.json { render json: @beneficiary.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /beneficiaries/1
  # DELETE /beneficiaries/1.json
  def destroy
    @beneficiary.destroy
    respond_to do |format|
      format.html { redirect_to beneficiaries_url, notice: 'Beneficiary was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def habilitar
    if @beneficiary.habilitar!
      @beneficiary.update(:user_updated_id => current_user.id)
      redirect_to @beneficiary, notice: I18n.t('beneficiaries.controller.enable')
    end
  end

  #Eliminar Logico
  def inhabilitar
    if @beneficiary.inhabilitar!
      @beneficiary.update(:user_updated_id => current_user.id)
      redirect_to @beneficiary, notice: I18n.t('beneficiaries.controller.disable')
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_beneficiary
      @beneficiary = Beneficiary.find(params[:id])
    end

    def title
      @titulobanner =  I18n.t ('.general.models.beneficiaries')
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def beneficiary_params
      params.require(:beneficiary).permit(
        :people_attributes => [
          :id,
          :first_name,
          :surname,
          :type_identification,
          :identification_document,
          :date_birth,
          :sex,
          :phone,
          :cellphone
        ]
      )
    end
    def inicializar_attr_accessor
       @beneficiary.people.beneficiario = true
       @beneficiary.people.employee = false
       @beneficiary.people.cliente = false
    end
end
