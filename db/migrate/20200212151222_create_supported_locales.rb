class CreateSupportedLocales < ActiveRecord::Migration[6.0]
  def change
    create_table :supported_locales do |t|
      t.string :name

      t.timestamps
    end
  end
end
