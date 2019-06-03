class CreatePerfis < ActiveRecord::Migration[5.2]
  def change
    create_table :perfis do |t|
    	t.string :nome, null: false
    	t.boolean :desativado, default: false

      t.timestamps
    end
  end
end
