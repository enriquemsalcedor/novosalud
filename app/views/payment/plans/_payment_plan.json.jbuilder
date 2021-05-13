json.extract! payment_plan, :id, :valid_since, :valid_until, :user_created_id, :user_updated_id, :customer_id, :status, :created_at, :updated_at
json.url payment_plan_url(payment_plan, format: :json)