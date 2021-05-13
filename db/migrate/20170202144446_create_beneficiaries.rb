class CreateBeneficiaries < ActiveRecord::Migration[5.0]
  def change
    create_table :beneficiaries do |t|
      t.references :people, foreign_key: true
      t.integer :user_created_id
      t.integer :user_updated_id

      t.timestamps
    end
  end
end
