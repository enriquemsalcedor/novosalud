class CreateStatuses < ActiveRecord::Migration[5.0]
  def change
    create_table :statuses do |t|
      t.string :name, limit: 50
      t.references :category, index:true

      t.timestamps
    end

    add_foreign_key :statuses, :categories, column: :category_id
  end
end
