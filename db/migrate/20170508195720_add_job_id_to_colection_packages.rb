class AddJobIdToColectionPackages < ActiveRecord::Migration[5.0]
  def change
    add_column :colection_packages, :job_id, :integer
  end
end
