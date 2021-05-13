class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  add_breadcrumb "Inicio", :root_path

  # GET /contacts/new
  def new
    @contact = Contact.new
    add_breadcrumb "Contactos", "/contacts/new"
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        ContactMailer.send_contact_form(@contact).deliver_now
        format.html { redirect_to new_contact_path, notice: 'Mensaje enviado exitosamente.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:name, :email, :subject, :message)
    end
end
