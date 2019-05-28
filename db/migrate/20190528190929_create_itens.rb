class CreateItens < ActiveRecord::Migration[5.2]
  def change
    create_table :itens do |t|
    	t.integer :quantidade
    	t.string :nome, null: false

      t.timestamps
    end
  end
end
