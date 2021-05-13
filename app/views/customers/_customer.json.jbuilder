json.extract! customer, :id, :customercode, :people_id, :created_at, :updated_at
json.url customer_url(customer, format: :json)