class AddEmailstoInitialValues < ActiveRecord::Migration[5.0]
  def change
  	add_column :initial_values, :administration_email, :string, limit: 60
  	add_column :initial_values, :call_center_email, :string, limit: 60
  end
end
