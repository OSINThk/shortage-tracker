json.extract! report, :id, :coordinates, :notes, :created_at, :updated_at
json.url report_url(report, format: :json)
