json.extract! report, :id, :long, :lat, :notes, :created_at, :updated_at
json.url report_url(report, format: :json)
