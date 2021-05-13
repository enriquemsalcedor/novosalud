class PeopleController < ApplicationController
  before_action :title
  before_action :set_people, only: [:show, :edit, :update, :destroy]
  #skip_before_filter :verify_authenticity_token
  


  # GET /people
  # GET /people.json
  def index
    @people = People.all
  end

  # GET /people/1
  # GET /people/1.json 
  def show  
  end 

  # GET /people/new  
  def new 
    @people = People.new
  end
  # GET /people/1/edit
  def edit

  end

  # POST /people
  # POST /people.json
  def create
    @people = People.new(people_params)   
    @people.user_created_id = current_user.id        
    respond_to do |format|
      if @people.save
        format.html { redirect_to @people, notice: 'Persona creada con éxito.' }
        format.json { render :show, status: :created, location: @people }
      else
        format.html { render :new }
        format.json { render json: @people.errors, status: :unprocessable_entity }
      end
    end  
  end

  # PATCH/PUT /people/1 
  # PATCH/PUT /people/1.json
  def update
    @people.user_updated_id = current_user.id
    respond_to do |format|
      if @people.update(people_params)
        format.html { redirect_to @people, notice: 'Persona actualizada con éxito.' }
        format.json { render :show, status: :ok, location: @people }
      else
        format.html { render :edit }
        format.json { render json: @people.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @people.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Persona eliminada con éxito.' }
      format.json { head :no_content }
    end
  end

  def title
    @titulobanner =  I18n.t ('.general.models.peoples')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_people
      @people = People.find(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def people_params
      params.require(:people).permit(:first_name,:surname, :type_identification, :identification_document, 
        :email, :date_birth, :sex, :civil_status, :phone, :cellphone, :address )
    end

end
  