class Territory::City < ApplicationRecord
  has_many :people
  belongs_to :territory_state, class_name: Territory::State , foreign_key: :territory_state_id
end
 