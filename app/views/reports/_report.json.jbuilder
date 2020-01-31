json.extract! report, :id, :ip, :notes, :coordinates, :user_id, :created_at, :updated_at
json.url report_url(report, format: :json)
