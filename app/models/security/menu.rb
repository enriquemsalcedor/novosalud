class Security::Menu < ApplicationRecord
  belongs_to :parent, class_name: Security::Menu, foreign_key: "menu_id"
  has_many :children, class_name: Security::Menu, foreign_key: "menu_id"
  #Para la anexacion de nuevos opciones de menú para el canal administrativo se debe crear una nueva migración para tomar
  #como ejemplo revisar la migracion 20170427141057_add_menu_option.rb 
end
