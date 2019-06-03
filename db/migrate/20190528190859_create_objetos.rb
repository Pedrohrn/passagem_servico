class CreateObjetos < ActiveRecord::Migration[5.2]
  def change
    create_table :objetos do |t|
    	t.integer :categoria_id, null: false
    	t.integer :passagem_servico_id
    	t.integer :perfil_id

    	t.json :items, default: []

      t.timestamps
    end
  end
end
