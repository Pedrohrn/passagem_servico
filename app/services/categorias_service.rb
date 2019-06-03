class CategoriasService
	def self.model() ::Categoria; end

	def self.index(params)
		list = Categoria.all
	end

	def self.create(novaCategoria)
		categoria = model.new(novaCategoria)

		return [:success, {categoria: categoria}] if categoria.save
		[:error, categoria.errors.full_messages]
	end

	def self.update(novaCategoria)
		categoria = Categoria.find(novaCategoria[:id])
		categoria.update!(nome: novaCategoria[:nome])

		return [:success, {categoria: categoria}] if categoria.update
		[:error, categoria.errors.full_messages]
	end

	def self.disabled(novaCategoria)
		categoria = Categoria.find(params[:id])
	end

#	def self.destroy(novaCategoria)
#		categoria = Categoria.find(params[:id])
#		categoria.destroy

#		return [:success, {categoria: categoria}] if categoria.destroy
#		[:error, categoria.errors.full_messages]
#	end
end
