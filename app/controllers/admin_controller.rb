class AdminController < ApplicationController
  before_action :title
  before_action :verificar_usuario
  layout :set_layout

  def index
     session[:controller_layout] = params[:controller]
     session[:layout_action] = params[:action]
  end


   private
    # Use callbacks to share common setup or constraints between actions.


    def title
      @titulobanner =  I18n.t ('.general.model.login')
    end

    def verificar_usuario

      if user_signed_in?   
        @user_employee = Employee.find_by user_id: current_user.id
                
        unless @user_employee.nil?
          render partial: 'layouts/admin2'  
          session[:employee_id] = @user_employee.id      
        else  
          sign_out_and_redirect(current_user)
          flash.notice = "Se cerro tu sesión"   
        end  
      end  
    end  

  def set_layout
    unless session[:layout] == 'admin'
      session[:layout] = 'admin'
    end
  end

end