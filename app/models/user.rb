class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  #has_many :history_passwords

  attr_accessor :login
  #validates_associated :history_passwords

  has_one :employee, class_name: Employee, foreign_key: :user_id
  devise :database_authenticatable, :registerable, :recoverable, 
  :rememberable, :trackable, :validatable, :lockable, 
  :confirmable, :authentication_keys => [:login]


  has_many :sale_quotations , class_name: Sale::Quotation, foreign_key: :user_id
  has_one :customer
  has_one :company, class_name: Business::Company, foreign_key: :user_id
  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

  validate :password_complexity
  validate :validate_username 
  validates :password,:presence =>{:message =>"Debe ingresar una contraseña."}, :if => :is_registration?
  validates :password_confirmation,:presence =>{:message =>"Debe ingresar la confirmación de la contraseña."}, :if => :is_registration? 

  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  def password_complexity
    if password.present? and not password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[\W])/)
      errors.add :password, "La contraseña debe incluir al menos una letra minúscula, una letra mayúscula y un símbolo"
    end
  end

  def active_for_authentication?
    super and self.is_active?
  end

  def login=(login)
    @login = login
  end

  def login
    @login || self.username || self.email
  end

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:login].nil?
        where(conditions).first
      else
        where(login: conditions[:login]).first
      end
    end
  end

  def datos_aleatorios
    letras_MAYUSCULAS = %w{ A B C D E F G H I J K L M N O P Q R S T U V W X Y Z }
    letras_minusculas = %w{ a b c d e d g h i j k l m n o p q r s t u v w x y z }
    caracteres_especiales = %w{! " # $ % & * + , - . / : ; < = > ? @ _}
    numeros = %w{1 2 3 4 5 6 7 8 9 0}

    letra_M_aleat = rand(letras_MAYUSCULAS.length)
    letra_m_aleat = rand(letras_minusculas.length)
    caracteres_espec = rand(caracteres_especiales.length)
    num_aleat = rand(numeros.length)
    return letras_MAYUSCULAS[letra_M_aleat] + letras_minusculas[letra_m_aleat] + caracteres_especiales[caracteres_espec] + numeros[num_aleat]
  end

  def generar_password
    if self.id.nil?
      clave_aleatoria = ''
      2.times do
        clave_aleatoria << datos_aleatorios
      end
      self.password = clave_aleatoria
    end
  end

  def is_registration?
    if  $controller == "users/registrations"
      $controller = ""
      return true
    end
  end

  def existen_menos_3_password?
    @count_user = HistoryPassword.where(:user_id => self.id).count
    if @count_user < 3
      return true
    else  
      return false
    end   
  end

  def existe_password?
    #En este metodo verifico si la contraseña que deseo registrar ya existe en la tabla historial
    @history_user = HistoryPassword.find_by(user_id: self.id, password: $password)
    if @history_user.nil? 
      return true
    else
      return false
    end    
  end

  def registrar_password_menos_3_registros?
    #Verifico si hay menos de 3 registros con ese ese user_id
    if self.verificar_passwords?
      HistoryPassword.create(:user_id => self.id, :password => $password)
      return true
    else 
      return false
    end      
  end

  def registrar_password_mayor_3_registros?
    if self.verificar_passwords?
      HistoryPassword.where(:user_id => self.id).order(updated_at: :asc).first.update_attributes(:password => $password)
      return true
    else 
      return false
    end
  end

  def verificar_passwords?
    @user_reload = User.find_by id: self.id
    @user_password_new = @user_reload.encrypted_password
    if $clave != @user_password_new
      return true
    end  
  end  

  def similitud_datos_personales?
    #Consulto los datos registrados en empleado, cliente o pymes y los comparo
    #con la contraseña que desea registrar para verificar si son iguales
    @employee = Employee.find_by(user_id: self.id)
    @client = Customer.find_by(user_id: self.id)     
    @pymes = Business::Company.find_by(user_id: self.id)
    if !@employee.nil?
      first_name_igual = $password.downcase.scan(@employee.first_name.downcase)
      second_name_igual = $password.downcase.scan(@employee.second_name.downcase)
      surname_igual = $password.downcase.scan(@employee.surname.downcase)
      second_surname_igual = $password.downcase.scan(@employee.second_surname.downcase )
      identification_document_igual = $password.scan(@employee.identification_document.to_s)
      if @employee.second_name.present? && @employee.second_surname.present?
        if first_name_igual.empty? && second_name_igual.empty? && surname_igual.empty? && second_surname_igual.empty? && identification_document_igual.empty?
          return false
        else
          return true
        end
      elsif @employee.second_name.present?
        if first_name_igual.empty? && second_name_igual.empty? && surname_igual.empty? && identification_document_igual.empty?
          return false
        else
          return true
        end
      elsif @employee.second_surname.present? 
        if first_name_igual.empty? && surname_igual.empty? && second_surname_igual.empty? && identification_document_igual.empty?
          return false
        else
          return true
        end
      else
        if first_name_igual.empty? && surname_igual.empty? && identification_document_igual.empty?
          return false
        else
          return true
        end
      end        
    elsif !@client.nil?
      first_name_igual = $password.downcase.scan(@client.people.first_name.downcase)
      surname_igual = $password.downcase.scan(@client.people.surname.downcase)
      identification_document_igual = $password.scan(@client.people.identification_document.to_s)
      phone_igual = $password.scan(@client.people.phone.to_s)
      if first_name_igual.empty? && surname_igual.empty? && identification_document_igual.empty? && phone_igual.empty?
        return false
      else
        return true
      end
    elsif !@pymes.nil?
      name_igual = $password.downcase.scan(@pymes.name.delete(' ').downcase)
      rif_igual = $password.scan(@pymes.rif.to_s)
      email_igual = $password.downcase.scan(@pymes.email.downcase)
      phone_igual = $password.scan(@pymes.phone.to_s)
      firt_name_responsable_igual = $password.downcase.scan(@pymes.firt_name_responsable.downcase)
      last_name_responsable_igual = $password.downcase.scan(@pymes.last_name_responsable.downcase) 
      if name_igual.empty? && rif_igual.empty? && email_igual.empty? && phone_igual.empty? && firt_name_responsable_igual.empty? && last_name_responsable_igual.empty?
        return false
      else
        return true
      end    
    end  
  end
end
