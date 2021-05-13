class AddPeopleToEmployee < ActiveRecord::Migration[5.0]
  def change
    add_column :employees, :first_name, :string
    add_column :employees, :surname, :string
    add_column :employees, :type_identification, :string
    add_column :employees, :identification_document, :integer
  end
end
