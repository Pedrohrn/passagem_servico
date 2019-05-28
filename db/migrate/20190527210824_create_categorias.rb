class CreateCategorias < ActiveRecord::Migration[5.2]
  def change
    create_table :categorias do |t|
    	t.string :nome, null: :false
    	t.boolean :desativada, default: false

      t.timestamps
    end

    add_index :categorias, :nome
  end
end

