json.extract! product, :id, :title, :description, :value, :created_at, :updated_at
json.url product_url(product, format: :json)
