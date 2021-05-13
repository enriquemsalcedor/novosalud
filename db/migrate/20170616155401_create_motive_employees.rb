class CreateMotiveEmployees < ActiveRecord::Migration[5.0]
  def change
    create_table :motive_employees do |t|
    	t.string :motive, limit: 150
    	t.integer :employee_id
      t.string :status
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
