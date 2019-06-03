class Objeto < ApplicationRecord

	belongs_to :categoria

	def to_frontend_obj
		{
			id: id, categoria: categoria_obj, items: items_obj
		}
	end

	def categoria_obj
		categoria.slim_obj
	end

	def items_obj
		items
	end
end
