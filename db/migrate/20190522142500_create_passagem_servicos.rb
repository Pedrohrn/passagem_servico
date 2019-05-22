class CreatePassagemServicos < ActiveRecord::Migration[5.2]
  def change
    create_table :passagem_servicos do |t|
    	t.string :status, null: false

    	# Pessoa
    	t.integer :pessoa_saiu_id,   null: false
    	t.integer :pessoa_entrou_id, null: false

    	t.date :data, null: false

    	t.text :observacoes

    	t.timestamps
    end

    add_index :passagem_servicos, :status
    add_index :passagem_servicos, :data

    add_index :passagem_servicos, :pessoa_saiu_id
    add_index :passagem_servicos, :pessoa_entrou_id
  end
end
