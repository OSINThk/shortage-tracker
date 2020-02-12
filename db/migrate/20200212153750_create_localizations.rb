class CreateLocalizations < ActiveRecord::Migration[6.0]
  def change
    create_table :localizations do |t|
      t.references :localizable, polymorphic: true, null: false
      t.references :supported_locale, null: false, foreign_key: true
      t.text :value

      t.timestamps
    end
  end
end
