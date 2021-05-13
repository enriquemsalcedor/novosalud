json.extract! account, :id, :bank_id, :account_number, :account_type, :direction_web, :created_at, :updated_at
json.url account_url(account, format: :json)