class Perfil < ApplicationRecord
	validates_presence_of :nome, message: "Nome do perfil não pode ser vazio!"
	validates_uniqueness_of :nome, message: "Já existe um perfill com esse nome! Escolha outro."

	has_many :objetos

	accepts_nested_attributes_for :objetos

	def slim_obj
		{
			id: id,
			nome: nome,
			desativado: desativado,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:objetos] = objetos_obj
		attrs
	end

	def objetos_obj
		objetos.map(&:to_frontend_obj)
	end

end
