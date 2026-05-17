class AddRegiaoAtuacaoToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :regiao_atuacao, :string
  end
end
