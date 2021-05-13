# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171009133955) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "bank_id"
    t.string   "account_number"
    t.string   "account_type"
    t.string   "status"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "email",           limit: 60
  end

  create_table "banks", force: :cascade do |t|
    t.string   "name",               limit: 50
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.string   "status",             limit: 15, default: "Activo"
    t.string   "direction_web"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "beneficiaries", force: :cascade do |t|
    t.integer  "people_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "status",          limit: 15, default: "Activo"
    t.index ["people_id"], name: "index_beneficiaries_on_people_id", using: :btree
  end

  create_table "business_companies", force: :cascade do |t|
    t.string   "name",                     limit: 50
    t.string   "type_identification",      limit: 1
    t.string   "rif",                      limit: 15
    t.string   "email",                    limit: 60
    t.string   "phone",                    limit: 15
    t.string   "status",                   limit: 15,  default: "Activo"
    t.string   "firt_name_responsable",    limit: 50
    t.string   "last_name_responsable",    limit: 50
    t.string   "address",                  limit: 140
    t.integer  "user_id"
    t.integer  "business_company_type_id"
    t.integer  "territory_country_id"
    t.integer  "territory_state_id"
    t.integer  "territory_city_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.index ["business_company_type_id"], name: "index_business_companies_on_business_company_type_id", using: :btree
    t.index ["territory_city_id"], name: "index_business_companies_on_territory_city_id", using: :btree
    t.index ["territory_country_id"], name: "index_business_companies_on_territory_country_id", using: :btree
    t.index ["territory_state_id"], name: "index_business_companies_on_territory_state_id", using: :btree
    t.index ["user_id"], name: "index_business_companies_on_user_id", using: :btree
  end

  create_table "business_company_types", force: :cascade do |t|
    t.string   "name",            limit: 30
    t.integer  "limit"
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "colection_package_products", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "product_product_id"
    t.integer  "colection_package_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["colection_package_id"], name: "index_colection_package_products_on_colection_package_id", using: :btree
    t.index ["product_product_id"], name: "index_colection_package_products_on_product_product_id", using: :btree
  end

  create_table "colection_packages", force: :cascade do |t|
    t.string   "code",               limit: 20
    t.string   "description",        limit: 140
    t.date     "valid_since"
    t.date     "valid_until"
    t.float    "total_amount"
    t.string   "category",           limit: 15
    t.string   "terms",              limit: 200
    t.string   "status",             limit: 15,  default: "Inactivo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "job_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.string   "name",       limit: 50
    t.string   "email",      limit: 50
    t.string   "subject",    limit: 50
    t.string   "message",    limit: 200
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "customers", force: :cascade do |t|
    t.string   "customer_code",   limit: 15
    t.integer  "people_id"
    t.integer  "user_id"
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["people_id"], name: "index_customers_on_people_id", using: :btree
    t.index ["user_id"], name: "index_customers_on_user_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "employees", force: :cascade do |t|
    t.string   "second_name",               limit: 50
    t.string   "second_surname",            limit: 50
    t.string   "code_employee",             limit: 20
    t.string   "motive",                    limit: 150
    t.string   "status",                    limit: 15,  default: "Inactivo"
    t.boolean  "confirmed",                             default: false
    t.integer  "provider_provider_id"
    t.integer  "position_id"
    t.integer  "security_profiles_id"
    t.integer  "user_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.string   "email"
    t.string   "first_name"
    t.string   "surname"
    t.string   "type_identification"
    t.string   "identification_document"
    t.date     "date_valid"
    t.string   "type_profile"
    t.integer  "previous_profile_security"
    t.index ["position_id"], name: "index_employees_on_position_id", using: :btree
    t.index ["security_profiles_id"], name: "index_employees_on_security_profiles_id", using: :btree
    t.index ["user_id"], name: "index_employees_on_user_id", using: :btree
  end

  create_table "history_passwords", force: :cascade do |t|
    t.string   "password",   null: false
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_history_passwords_on_user_id", using: :btree
  end

  create_table "initial_values", force: :cascade do |t|
    t.integer  "days_validity"
    t.integer  "max_refech_service"
    t.integer  "number_employee"
    t.integer  "max_quantity_product"
    t.string   "email_max_quantity",    limit: 50
    t.string   "email_security",        limit: 50
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "days_validity_service"
    t.string   "administration_email",  limit: 60
    t.string   "call_center_email",     limit: 60
  end

  create_table "method_payments", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "motive_employees", force: :cascade do |t|
    t.string   "motive",          limit: 150
    t.integer  "employee_id"
    t.string   "status"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "motive_profiles", force: :cascade do |t|
    t.string   "motive"
    t.integer  "profile_id"
    t.string   "status"
    t.integer  "user_created_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "motives", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "movement_services", force: :cascade do |t|
    t.string   "code",                          limit: 15
    t.date     "date_service"
    t.date     "appointment_date"
    t.integer  "service_service_id"
    t.integer  "beneficiary_id"
    t.integer  "payment_contracted_product_id"
    t.integer  "provider_medico_provider_id"
    t.integer  "motive_id"
    t.string   "status",                        limit: 15
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "rif",             limit: 15
    t.string   "email",           limit: 60
    t.string   "address",         limit: 140
    t.string   "phone",           limit: 18
    t.integer  "user_updated_id"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "payment_contracted_packages", force: :cascade do |t|
    t.integer  "colection_package_id"
    t.integer  "plan_id"
    t.float    "price_contracted"
    t.string   "status",               limit: 15
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  create_table "payment_contracted_products", force: :cascade do |t|
    t.string   "code",                          limit: 15
    t.float    "price_contracted"
    t.integer  "plan_id"
    t.integer  "product_product_id"
    t.string   "status",                        limit: 15
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.date     "valid_until"
    t.integer  "job_id"
    t.integer  "payment_contracted_package_id"
  end

  create_table "payment_plans", force: :cascade do |t|
    t.string   "number_plan",       limit: 10
    t.integer  "customer_id"
    t.integer  "company_id"
    t.integer  "sale_quotation_id"
    t.integer  "method_payment_id"
    t.string   "status",            limit: 15
    t.float    "total_amount"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "bank_id"
    t.string   "reference",         limit: 15
  end

  create_table "payment_transferences", force: :cascade do |t|
    t.integer  "bank_id"
    t.integer  "sale_quotation_id"
    t.string   "reference"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  create_table "people", force: :cascade do |t|
    t.string   "first_name",              limit: 50
    t.string   "surname",                 limit: 50
    t.string   "type_identification",     limit: 1
    t.string   "identification_document"
    t.string   "email",                   limit: 60
    t.date     "date_birth"
    t.string   "sex",                     limit: 10
    t.string   "phone"
    t.string   "cellphone",               limit: 15
    t.string   "address",                 limit: 140
    t.integer  "territory_country_id"
    t.integer  "territory_state_id"
    t.integer  "territory_city_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["territory_city_id"], name: "index_people_on_territory_city_id", using: :btree
    t.index ["territory_country_id"], name: "index_people_on_territory_country_id", using: :btree
    t.index ["territory_state_id"], name: "index_people_on_territory_state_id", using: :btree
  end

  create_table "positions", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "description",     limit: 140
    t.string   "status",          limit: 15,  default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "product_product_types", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "description",     limit: 140
    t.string   "status",          limit: 15,  default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  create_table "product_products", force: :cascade do |t|
    t.string   "code",                    limit: 20
    t.string   "name",                    limit: 50
    t.string   "category",                limit: 15
    t.string   "terms",                   limit: 700
    t.date     "publication_date"
    t.date     "expiration_date"
    t.string   "status",                  limit: 15
    t.integer  "speciality_id"
    t.integer  "product_product_type_id"
    t.float    "price"
    t.integer  "provider_provider_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "job_id"
    t.integer  "valid_days"
    t.string   "description",             limit: 700
  end

  create_table "provider_medico_providers", force: :cascade do |t|
    t.integer  "provider_provider_id"
    t.integer  "provider_medico_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["provider_medico_id"], name: "index_provider_medico_providers_on_provider_medico_id", using: :btree
    t.index ["provider_provider_id"], name: "index_provider_medico_providers_on_provider_provider_id", using: :btree
  end

  create_table "provider_medicos", force: :cascade do |t|
    t.string   "code_medico",     limit: 20
    t.integer  "people_id"
    t.integer  "speciality_id"
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "c_m_l",           limit: 20
    t.string   "phone_medico",    limit: 15
    t.index ["people_id"], name: "index_provider_medicos_on_people_id", using: :btree
    t.index ["speciality_id"], name: "index_provider_medicos_on_speciality_id", using: :btree
  end

  create_table "provider_provider_types", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "status",          limit: 15, default: "Activo"
  end

  create_table "provider_providers", force: :cascade do |t|
    t.integer  "clinic_code"
    t.string   "name",                            limit: 200
    t.string   "type_identification",             limit: 1
    t.string   "rif",                             limit: 15
    t.string   "phone",                           limit: 80
    t.string   "email",                           limit: 50
    t.string   "address",                         limit: 140
    t.string   "identification_document"
    t.string   "firt_name_responsable",           limit: 50
    t.string   "last_name_responsable",           limit: 50
    t.string   "phone_responsable",               limit: 15
    t.string   "position",                        limit: 50
    t.string   "email_responsable",               limit: 60
    t.integer  "territory_country_id"
    t.integer  "territory_state_id"
    t.integer  "territory_city_id"
    t.integer  "provider_provider_type_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "status",                          limit: 15,  default: "Activo"
    t.string   "type_identification_responsable", limit: 1
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "phone2",                          limit: 80
    t.string   "phone3",                          limit: 80
    t.index ["provider_provider_type_id"], name: "index_provider_providers_on_provider_provider_type_id", using: :btree
    t.index ["territory_city_id"], name: "index_provider_providers_on_territory_city_id", using: :btree
    t.index ["territory_country_id"], name: "index_provider_providers_on_territory_country_id", using: :btree
    t.index ["territory_state_id"], name: "index_provider_providers_on_territory_state_id", using: :btree
  end

  create_table "sale_package_quotations", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "colection_package_id"
    t.integer  "sale_quotation_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["colection_package_id"], name: "index_sale_package_quotations_on_colection_package_id", using: :btree
    t.index ["sale_quotation_id"], name: "index_sale_package_quotations_on_sale_quotation_id", using: :btree
  end

  create_table "sale_product_quotations", force: :cascade do |t|
    t.integer  "quantity"
    t.integer  "product_product_id"
    t.integer  "sale_quotation_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["product_product_id"], name: "index_sale_product_quotations_on_product_product_id", using: :btree
    t.index ["sale_quotation_id"], name: "index_sale_product_quotations_on_sale_quotation_id", using: :btree
  end

  create_table "sale_quotations", force: :cascade do |t|
    t.string   "quoting_number"
    t.string   "status",          limit: 15, default: "En_cotizacion"
    t.integer  "user_id"
    t.date     "valid_since"
    t.date     "valid_until"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.inet     "ip_quotation"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  create_table "security_menus", force: :cascade do |t|
    t.string   "description", limit: 30
    t.string   "codemenu",    limit: 255
    t.integer  "menu_id"
    t.boolean  "is_father",               default: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.string   "controller"
    t.boolean  "action",                  default: false
    t.string   "params"
  end

  create_table "security_profiles", force: :cascade do |t|
    t.string   "name",             limit: 50
    t.string   "position",         limit: 50
    t.string   "status",           limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.integer  "security_role_id"
    t.index ["security_role_id"], name: "index_security_profiles_on_security_role_id", using: :btree
  end

  create_table "security_role_menus", force: :cascade do |t|
    t.integer  "security_role_id"
    t.integer  "security_menu_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["security_menu_id"], name: "index_security_role_menus_on_security_menu_id", using: :btree
    t.index ["security_role_id"], name: "index_security_role_menus_on_security_role_id", using: :btree
  end

  create_table "security_role_profiles", force: :cascade do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "security_profile_id"
    t.integer  "security_role_id"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "security_role_type_id"
    t.index ["security_profile_id"], name: "index_security_role_profiles_on_security_profile_id", using: :btree
    t.index ["security_role_id"], name: "index_security_role_profiles_on_security_role_id", using: :btree
  end

  create_table "security_role_type_menus", force: :cascade do |t|
    t.integer  "security_role_type_id"
    t.integer  "security_role_menu_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["security_role_menu_id"], name: "index_security_role_type_menus_on_security_role_menu_id", using: :btree
    t.index ["security_role_type_id"], name: "index_security_role_type_menus_on_security_role_type_id", using: :btree
  end

  create_table "security_role_types", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "controller"
    t.boolean  "action",                     default: false
  end

  create_table "security_roles", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "status",          limit: 15, default: "Activo"
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  create_table "seed_migration_data_migrations", force: :cascade do |t|
    t.string   "version"
    t.integer  "runtime"
    t.datetime "migrated_on"
  end

  create_table "service_services", force: :cascade do |t|
    t.string   "code",                          limit: 15
    t.date     "date_service"
    t.date     "appointment_date"
    t.integer  "beneficiary_id"
    t.integer  "provider_medico_provider_id"
    t.integer  "motive_id"
    t.integer  "payment_contracted_product_id"
    t.string   "status",                        limit: 15
    t.string   "observation",                   limit: 140
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.integer  "job_id"
    t.index ["beneficiary_id"], name: "index_service_services_on_beneficiary_id", using: :btree
    t.index ["motive_id"], name: "index_service_services_on_motive_id", using: :btree
    t.index ["payment_contracted_product_id"], name: "index_service_services_on_payment_contracted_product_id", using: :btree
    t.index ["provider_medico_provider_id"], name: "index_service_services_on_provider_medico_provider_id", using: :btree
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "specialities", force: :cascade do |t|
    t.string   "name",            limit: 50
    t.string   "description",     limit: 140
    t.integer  "user_created_id"
    t.integer  "user_updated_id"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "status",          limit: 15,  default: "Activo"
  end

  create_table "statuses", force: :cascade do |t|
    t.string   "name",        limit: 50
    t.integer  "category_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.index ["category_id"], name: "index_statuses_on_category_id", using: :btree
  end

  create_table "territory_cities", force: :cascade do |t|
    t.string   "name",               limit: 50
    t.integer  "territory_state_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["territory_state_id"], name: "index_territory_cities_on_territory_state_id", using: :btree
  end

  create_table "territory_countries", force: :cascade do |t|
    t.string   "name",       limit: 50
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "territory_states", force: :cascade do |t|
    t.string   "name",                 limit: 50
    t.integer  "territory_country_id"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.index ["territory_country_id"], name: "index_territory_states_on_territory_country_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                    default: "",                    null: false
    t.string   "encrypted_password",       default: "",                    null: false
    t.string   "client_type"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",            default: 0,                     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",          default: 0,                     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "is_active",                default: true
    t.datetime "password_changed_at",      default: '2018-08-29 00:00:00'
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "username"
    t.boolean  "forget_username"
    t.boolean  "temporary_password"
    t.boolean  "temporary_password_valid"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["password_changed_at"], name: "index_users_on_password_changed_at", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["username"], name: "index_users_on_username", unique: true, using: :btree
  end

  add_foreign_key "beneficiaries", "people", column: "people_id"
  add_foreign_key "business_companies", "business_company_types"
  add_foreign_key "business_companies", "territory_cities"
  add_foreign_key "business_companies", "territory_countries"
  add_foreign_key "business_companies", "territory_states"
  add_foreign_key "business_companies", "users"
  add_foreign_key "colection_package_products", "colection_packages"
  add_foreign_key "colection_package_products", "product_products"
  add_foreign_key "customers", "people", column: "people_id"
  add_foreign_key "customers", "users"
  add_foreign_key "employees", "positions"
  add_foreign_key "employees", "security_profiles", column: "security_profiles_id"
  add_foreign_key "employees", "users"
  add_foreign_key "history_passwords", "users"
  add_foreign_key "people", "territory_cities"
  add_foreign_key "people", "territory_countries"
  add_foreign_key "people", "territory_states"
  add_foreign_key "provider_medico_providers", "provider_medicos"
  add_foreign_key "provider_medico_providers", "provider_providers"
  add_foreign_key "provider_medicos", "people", column: "people_id"
  add_foreign_key "provider_medicos", "specialities"
  add_foreign_key "provider_providers", "provider_provider_types"
  add_foreign_key "provider_providers", "territory_cities"
  add_foreign_key "provider_providers", "territory_countries"
  add_foreign_key "provider_providers", "territory_states"
  add_foreign_key "sale_package_quotations", "colection_packages"
  add_foreign_key "sale_package_quotations", "sale_quotations"
  add_foreign_key "sale_product_quotations", "product_products"
  add_foreign_key "sale_product_quotations", "sale_quotations"
  add_foreign_key "security_profiles", "security_roles"
  add_foreign_key "security_role_menus", "security_menus"
  add_foreign_key "security_role_menus", "security_roles"
  add_foreign_key "security_role_profiles", "security_profiles"
  add_foreign_key "security_role_profiles", "security_roles"
  add_foreign_key "security_role_type_menus", "security_role_menus"
  add_foreign_key "security_role_type_menus", "security_role_types"
  add_foreign_key "service_services", "beneficiaries"
  add_foreign_key "service_services", "motives"
  add_foreign_key "service_services", "payment_contracted_products"
  add_foreign_key "service_services", "provider_medico_providers"
  add_foreign_key "statuses", "categories"
  add_foreign_key "territory_cities", "territory_states"
  add_foreign_key "territory_states", "territory_countries"
end
