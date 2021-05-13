class HistoryPassword < ApplicationRecord
	#validates :password, uniqueness: { scope: :user_id,
	# message: "La contraseña que desea registrar ya ha sido utilizada en las ultimas 3 actualizaciones." }
end
#