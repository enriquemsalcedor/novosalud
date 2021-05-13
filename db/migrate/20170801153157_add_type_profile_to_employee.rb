class AddTypeProfileToEmployee < ActiveRecord::Migration[5.0]
  def change
    add_column :employees, :date_valid, :date
    add_column :employees, :type_profile, :string
    add_column :employees, :previous_profile_security, :integer
  end
end
