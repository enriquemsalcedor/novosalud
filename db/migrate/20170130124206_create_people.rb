class CreatePeople < ActiveRecord::Migration[5.0]
  def change
    create_table :people do |t|
      t.string :first_name, limit: 50
      t.string :surname, limit: 50
      t.string :type_identification, limit: 1
      t.integer :identification_document
      t.string :email, limit: 60
      t.date :date_birth
      t.string :sex, limit: 10
      t.string :phone, limit: 15
      t.string :cellphone, limit: 15
      t.string :address, limit: 140
      t.references :territory_country, foreign_key: true
      t.references :territory_state, foreign_key: true
      t.references :territory_city, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
 
