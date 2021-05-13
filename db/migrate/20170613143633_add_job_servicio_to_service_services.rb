class AddJobServicioToServiceServices < ActiveRecord::Migration[5.0]
  def change
    add_column :service_services, :job_id, :integer
  end
end
