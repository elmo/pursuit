json.extract! campaign, :id, :client_customer_id, :campaign_id, :name, :status, :budget, :created_at, :updated_at
json.url campaign_url(campaign, format: :json)
