class AddSpatialIndexToReports < ActiveRecord::Migration[6.0]
  def change
    change_table :reports do |t|
      t.index :coordinates, using: :gist
    end
  end
end
