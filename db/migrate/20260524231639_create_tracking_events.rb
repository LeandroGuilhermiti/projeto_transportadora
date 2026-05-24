class CreateTrackingEvents < ActiveRecord::Migration[8.1]
  def change
    create_table :tracking_events do |t|
      t.references :package, null: false, foreign_key: true
      t.string :status
      t.string :descricao
      t.string :localizacao

      t.timestamps
    end
  end
end
