json.extract! product_detail, :id, :scarcity, :price, :notes, :product_id, :report_id, :created_at, :updated_at
json.url product_detail_url(product_detail, format: :json)
