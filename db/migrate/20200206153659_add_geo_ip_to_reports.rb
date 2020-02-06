class AddGeoIpToReports < ActiveRecord::Migration[6.0]
  def change
    add_column :reports, :geo_ip, :jsonb
    add_index :reports, :geo_ip, using: :gin
  end
end
