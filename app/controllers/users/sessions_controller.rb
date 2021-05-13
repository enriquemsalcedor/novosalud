class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  after_action :verificar_cotizaciones, only: [:create]
  after_action :cargar_menu, only:[:create]
  #GET /resource/sign_in

  def new
    $client= params[:cliente]
    if user_signed_in?
      if params[:cliente].present?
        @user_employee = Employee.find_by user_id: current_user.id
        @user_person = Customer.find_by user_id: current_user.id
        @user_company = Business::Company.find_by user_id: current_user.id
        unless @user_employee.nil?
          session[:employee_id] = @user_employee.id
        else
          unless @user_person.nil?
            session[:customer_id] = @user_person.id
          else
            unless @user_company.nil?
              session[:company_id] = @user_company.id
            end
          end
        end
      end
    end
    super
  end

  # POST /resource/sign_in
  def create
    if user_signed_in?
      @user_employee = Employee.find_by user_id: current_user.id
      @user_person = Customer.find_by user_id: current_user.id
      @user_company = Business::Company.find_by user_id: current_user.id
      unless @user_employee.nil?
        session[:employee_id] = @user_employee.id
      else
        unless @user_person.nil?
          session[:customer_id] = @user_person.id
        else
          unless @user_company.nil?
            session[:company_id] = @user_company.id
          end
        end
      end
    else
      @user = User.find_by(email: params[:user][:login])
      @user_admin = User.find_by(username: params[:user][:login], id: 1)
      if @user_admin.present?
        @user_admin.update(failed_attempts: 0)
      end  
      unless @user.nil?
        unless params[:user][:login].empty?
          actualizar_failed_attempts
        end  
      end  
      verificar_layout
    end
    super
  end

  # DELETE /resource/sign_out
  def destroy
   session[:layout] = params[:layout]
   $client = ''
   super
  end

  def title
    @titulobanner =  I18n.t ('.general.model.login')
  end


  #configure auto_session_timeout
  def active
    render_session_status
  end

  def timeout
    if session[:layout] == 'admin'
      session[:layout] = 'admin'
      redirect_to "/admin"
      flash[:notice] = I18n.t('general.action.response.employee.session_status')
    else
      session[:layout] = 'application'
      redirect_to "/users/sign_in"
      flash[:notice] = I18n.t('general.action.response.employee.session_status')
    end
  end

  #  def destroy
  #    super
  #  end
  # protected

  # If you have extra params to permit, append them to the sanitizer.
  #def configure_sign_in_params
  #  devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  #end
  private
    def verificar_cotizaciones
      @cotizacion_temporal = Sale::Quotation.find_by(ip_quotation: request.remote_ip, user_id: nil)
      unless @cotizacion_temporal.nil?
      @package_quotations = @cotizacion_temporal.sale_package_quotation.order(id: :asc)
      @product_quotations = @cotizacion_temporal.sale_product_quotations.order(id: :asc)
        unless current_user.customer.nil?       
          @product_quotations.each do |product|
           if (product.product_product.category == 'PYMES')
            product.destroy!
          end
          flash[:notice_product] = "Se han eliminado producto(s) de su cotización que no pertenecian a su segmento (Individual)."           
          end
          @usuario_cotizacion = Sale::Quotation.find_by(status: 'En_cotizacion', user_id: current_user.id)
          #verificamos si existe ya el user_id que esta ingresando posee una cotizacion, de ser positiva
          #se procede a actualizar las cantidades o a actualizar la cotizacion y luego se borra la cotizacion temporal
            if @usuario_cotizacion.present?
              @lis_products = Sale::ProductQuotation.where(sale_quotation_id: @cotizacion_temporal.id)
              @lis_products.each do |product|                  
                  @producto_similar = Sale::ProductQuotation.find_by(sale_quotation_id: @usuario_cotizacion.id,product_product_id: product.product_product_id)
                if @producto_similar.present?
                  @producto_similar.update(quantity: @producto_similar.quantity + product.quantity)
                  product.destroy!
                else
                  product.update(sale_quotation_id:@usuario_cotizacion.id)
                end
              end                
              @cotizacion_temporal.destroy!    
            else
              @cotizacion_temporal.update(user_id: current_user.id)  
            end 
        else
          @product_quotations.each do |product|
            if (product.product_product.category == 'Individual')
              product.destroy!
            end
            flash[:notice_product] = "Se han eliminado producto(s) de su cotización que no pertenecian a su segmento (PYMES)."          
          end
          @empresa_cotizacion = Sale::Quotation.find_by(status: 'En_cotizacion', user_id: current_user.id)
          #verificamos si existe ya el user_id que esta ingresando posee una cotizacion, de ser positiva
          #se procede a actualizar las cantidades o a actualizar la cotizacion y luego se borra la cotizacion temporal
            if @empresa_cotizacion.present?
              @lis_products = Sale::ProductQuotation.where(sale_quotation_id: @cotizacion_temporal.id)
              @lis_products.each do |product|                  
                  @producto_similar = Sale::ProductQuotation.find_by(sale_quotation_id: @empresa_cotizacion.id,product_product_id: product.product_product_id)
                if @producto_similar.present?
                  @producto_similar.update(quantity: @producto_similar.quantity + product.quantity)
                  product.destroy!
                else
                  product.update(sale_quotation_id:@empresa_cotizacion.id)
                end
              end                
              @cotizacion_temporal.destroy!    
            else
              @cotizacion_temporal.update(user_id: current_user.id)  
            end           
        end

        if current_user.customer.nil?
          @product_quotations.each do |product|
            if (product.product_product.category == 'Individual')
              product.destroy!
            end
            flash[:notice_product] = "Se han eliminado producto(s) de su cotización que no pertenecian a su segmento (PYMES)."          
          end
          @package_quotations.each do |package|
            if (package.colection_package.category == 'Individual')
              package.destroy!
            end 
            flash[:notice_package] = "Se han eliminado paquete(s) de su cotización que no pertenecian a su segmento (PYMES)."          
          end
        else
          @product_quotations.each do |product|
            if (product.product_product.category == 'PYMES')
              product.destroy!
            end
            flash[:notice_product] = "Se han eliminado producto(s) de su cotización que no pertenecian a su segmento (Individual)."           
          end
          @package_quotations.each do |package|
            if (package.colection_package.category == 'PYMES')
              package.destroy!
            end 
            flash[:notice_package] = "Se han eliminado paquete(s) de su cotización que no pertenecian a su segmento (Individual)."          
          end
        end
      end
    end

    def cargar_menu
      if current_user.client_type == 'empleado'
         $menu = []
         session[:menu] = []
         hijos = []
         hash_menu = {}
          current_user.employee.security_profile.security_role.security_menus.each do |menu|
            if hash_menu[menu.description].nil?
              hash_menu[menu.description] = menu
              unless menu.parent.nil?
                hash_menu[menu.parent.description] = menu.parent
                unless menu.parent.parent.nil?
                  hash_menu[menu.parent.parent.description] = menu.parent.parent
                end
              end
            end
          end
          session[:menu] = hash_menu.values.sort
          $menu = hash_menu.values
      end
    end

    def verificar_layout
      if session[:layout] == 'admin'
       session[:layout] = 'admin'
      else
        session[:layout] = 'application'
      end
    end

    def actualizar_failed_attempts
      @user = User.find_by(email: params[:user][:login])
      if @user.client_type == 'persona' || @user.client_type == 'empresa'
        @user.update(failed_attempts: 0)
      end  
    end
end
