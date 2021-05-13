Rails.application.routes.draw do
  namespace :product do
    resources :products
  end
  root     "home#index"

  devise_for :users, controllers: {sessions: "users/sessions", passwords: 'users/passwords',  registrations: 'users/registrations', :confirmations => "users/confirmations" , :unlocks => 'users/unlocks'}
  #configuración para la gema auto-session-timeout
  devise_scope :user do
    match 'active'            => 'users/sessions#active',               via: :get  
    match 'timeout'           => 'users/sessions#timeout',              via: :get   
  end 
  
  get 'list', to: 'home#list'
  get 'list_search', to: 'home#list_search'
  get 'redireccionamiento_verificar', to: 'home#redireccionamiento_verificar'
  get 'plist', to: 'home#plist'
  get 'details/:id', to: 'home#details'
  get 'promotion/:id', to: 'home#promotion'
  get 'promotions', to: 'home#promotions'
  get 'pymes_promotions', to: 'home#pymes_promotions'
  get 'cart', to: 'home#cart'
  get 'quotation_history', to: 'home#quotation_history'
  get 'plan_history', to: 'home#plan_history'
  get 'expired_quotation', to: 'home#expired_quotation'
  get 'clinics', to: 'home#clinics'
  get 'clinics/:id', to: 'home#clinics_details'
  get 'admin', to: 'admin#index'
  get 'decision', to: 'home#decision'
  get 'message', to: 'home#message'
  get "blocked_user", to: "employees#blocked_user"
  get "forget_username", to: "employees#forget_username"
  get "forget_username_list", to: "employees#forget_username_list"
  get "forget_password", to: "employees#forget_password"
  post "check_send_username", to: "employees#check_send_username"
  get ':id/transference' , to: 'home#transference'
  get 'decision_transference', to: 'home#decision_transference'
  get 'profile', to: 'employees#profile'

  resources :people
  resources :organizations
  resources :initial_values
  resources :contacts

  resources :positions
    put "/positions/:id/inhabilitar", to:"positions#inhabilitar"
    put "/positions/:id/habilitar", to:"positions#habilitar"

  resources :specialities
    put "/specialities/:id/inhabilitar", to:"specialities#inhabilitar"
    put "/specialities/:id/habilitar", to:"specialities#habilitar"

  resources :banks
    put "/banks/:id/habilitar", to: "banks#habilitar"
    put "/banks/:id/inhabilitar", to: "banks#inhabilitar"

  resources :motives
    put "/motives/:id/inhabilitar", to:"motives#inhabilitar"
    put "/motives/:id/habilitar", to:"motives#habilitar"

  resources :method_payments
    put "/method_payments/:id/inhabilitar", to:"method_payments#inhabilitar"
    put "/method_payments/:id/habilitar", to:"method_payments#habilitar"

  resources :beneficiaries
    put "/beneficiaries/:id/inhabilitar", to: "beneficiaries#inhabilitar"
    put "/beneficiaries/:id/habilitar", to: "beneficiaries#habilitar"

  resources :customers
    put "/customers/:id/habilitar", to: "customers#habilitar"
    put "/customers/:id/inhabilitar", to: "customers#inhabilitar"

  resources :employees
    post "/employees/:id/habilitar", to: "employees#habilitar"
    post '/employees/:id/inhabilitar', to: "employees#inhabilitar"
    get '/employees/:id/motive', to: 'employees#motive'
    post "/employees/:id/eliminar_logico", to: "employees#eliminar_logico"
    put "/employees/:id/unblocked", to: "employees#unblocked"
    put "/employees/:id/resend_username", to: "employees#resend_username"
    put "/employees/:id/resend_password", to: "employees#resend_password"
    post '/employees/:id/update_user',to: 'employees#update_user'
    get "/employees/:id/redireccionamiento_eliminar", to: "employees#redireccionamiento_eliminar"
    get "/employees/:id/show_list", to: "employees#show_list"

  resources :accounts
    put "/accounts/:id/habilitar", to: "accounts#habilitar"
    put "/accounts/:id/inhabilitar", to: "accounts#inhabilitar"


  namespace :colection do
    resources :packages
      put "/packages/:id/habilitar", to: "packages#habilitar"
      put "/packages/:id/inhabilitar", to: "packages#inhabilitar"
      get "/packages/:id/destroy_package_product", to: "packages#destroy_package_product"
      get "/packages/:id/verificar_productos", to: "packages#verificar_productos"

    resources :package_products
  end

  namespace :product do
    resources :product_types
      put "/product_types/:id/inhabilitar", to:"product_types#inhabilitar"
      put "/product_types/:id/habilitar", to:"product_types#habilitar"

    resources :products
      put "/products/:id/inhabilitar", to:"products#inhabilitar"
      put "/products/:id/habilitar", to:"products#habilitar"

    resources :product_providers
  end

  namespace :business do
    resources :companies
      put "/company_types/:id/inhabilitar", to:"company_types#inhabilitar"
      put "/company_types/:id/habilitar", to:"company_types#habilitar"

    resources :company_types
      put "/companies/:id/inhabilitar", to:"companies#inhabilitar"
      put "/companies/:id/habilitar", to:"companies#habilitar"
  end

  namespace :security do
    resources :profiles
      post "/profiles/:id/inhabilitar", to:"profiles#inhabilitar"
      put "/profiles/:id/habilitar", to:"profiles#habilitar"
      get '/profiles/:id/motive', to: 'profiles#motive'

    resources :roles
      put "/roles/:id/inhabilitar", to:"roles#inhabilitar"
      put "/roles/:id/habilitar", to:"roles#habilitar"
      get 'redir', to: 'roles#redir'

    resources :role_types
      put "/role_types/:id/inhabilitar", to:"role_types#inhabilitar"
      put "/role_types/:id/habilitar", to:"role_types#habilitar"
    resources :role_type_menus
    resources :role_profiles
    resources :role_menus
  end

  namespace :provider do
    resources :provider_types
      put "/provider_types/:id/inhabilitar", to:"provider_types#inhabilitar"
      put "/provider_types/:id/habilitar", to:"provider_types#habilitar"

    resources :providers
      put "/providers/:id/inhabilitar", to:"providers#inhabilitar"
      put "/providers/:id/habilitar", to:"providers#habilitar"

    resources :medicos
      put "/medicos/:id/inhabilitar", to:"medicos#inhabilitar"
      put "/medicos/:id/habilitar", to:"medicos#habilitar"

    resources :medico_providers
  end

      get 'sale/quotations/reporte', to: "sale/quotations#reporte"
  namespace :sale do
    get 'actualizar_cantidad', to: 'package_quotations#actualizar_cantidad'
    get 'actualizar_cantidad_producto', to: 'product_quotations#actualizar_cantidad_producto'
    resources :quotations
      put "/quotations/:id/pagar", to:"quotations#pagar"
      put "/quotations/:id/cotizar", to:"quotations#cotizar"
      put "/quotations/:id/comprobante", to:"quotations#comprobante"
      put "/quotations/:id/reactivar", to:"quotations#reactivar"

      get 'quotations/:id/pay' , to: 'quotations#pay'
      get '/reactivar' , to: 'quotations#reactivate'
      get 'quotations/:id/view' , to: 'quotations#view'

    resources :package_quotations
    resources :product_quotations
  end

  namespace :payment do
    get 'contracted_products', to: "contracted_products#index"
    get 'contracted_products/:id', to: "contracted_products#show"
    resources :plans
    get 'plans_cierre' , to: 'plans#cierre'

    resources :transferences, only: [:new, :create]
  end

  namespace :service do
    resources :services
      put "/services/:id/reagendar", to: "services#reagendar"
      put "/services/:id/cancelar", to: "services#cancelar"
      put "/services/:id/anular", to: "services#anular"
    get 'reports' , to: 'services#report'

  end

  namespace :clinic do
    get 'clinic_service', to: "clinic_service#index"
    put "clinic_service/:id/atender", to: "clinic_service#atender"
    get 'reports', to: "clinic_service#report"
    get 'report_active', to: "clinic_service#report_active"
    get 'pending_date', to: "clinic_service#pending_date"
  end
  match '*path', to: redirect('/'), via: :all
end
