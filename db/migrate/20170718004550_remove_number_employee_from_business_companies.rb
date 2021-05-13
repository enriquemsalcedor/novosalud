class RemoveNumberEmployeeFromBusinessCompanies < ActiveRecord::Migration[5.0]
  def change
    remove_column :business_companies, :number_employee, :integer
  end
end
