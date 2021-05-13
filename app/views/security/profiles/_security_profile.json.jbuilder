json.extract! security_profile, :id, :name, :user_created_id, :user_updated_id, :status, :created_at, :updated_at
json.url security_profile_url(security_profile, format: :json)