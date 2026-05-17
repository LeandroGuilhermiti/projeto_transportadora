class AddRegiaoToPackages < ActiveRecord::Migration[8.1]
  def change
    add_column :packages, :regiao, :string
  end
end
