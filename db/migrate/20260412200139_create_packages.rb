class CreatePackages < ActiveRecord::Migration[8.1]
  def change
    create_table :packages do |t|
      t.string :codigo_rastreio
      t.string :destinatario
      t.text :endereco
      t.string :status
      t.decimal :peso
      t.string :dimensoes
      t.integer :driver_id

      t.timestamps
    end
  end
end
