class Categoria < ApplicationRecord
	validates_presence_of :nome, message: "Nome da categoria não pode ser vazio!"
	validates_uniqueness_of :nome, message: "Essa categoria já existe!"

	has_many :objetos

	def slim_obj
		{
			id: id,
			nome: nome,
			desativada: desativada,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end
end
