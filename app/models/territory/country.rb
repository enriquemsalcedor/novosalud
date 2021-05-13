class Territory::Country < ApplicationRecord
	has_many :territory_states, class_name: Territory::State, foreign_key: :territory_country_id
end
