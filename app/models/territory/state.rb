class Territory::State < ApplicationRecord
	has_many :territory_cities, class_name: Territory::City, foreign_key: :territory_state_id
	belongs_to :territory_country, class_name: Territory::Country , foreign_key: :territory_country_id
end
