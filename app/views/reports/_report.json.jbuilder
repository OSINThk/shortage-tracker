json.extract! report, :id, :long, :lat, :notes, :created_at
json.product_detail report.product_detail, partial: "reports/product_detail", as: :product_detail
json.url report_url(report, format: :json)
