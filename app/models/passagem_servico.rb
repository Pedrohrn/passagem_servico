class PassagemServico < ApplicationRecord
	def slim_obj
		{
			id: id
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end
end
