class CreateObjetos < ActiveRecord::Migration[5.2]
  def change
    create_table :objetos do |t|
    	t.integer :categoria_id, null: false

      t.timestamps
    end
  end
end
