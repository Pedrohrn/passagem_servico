class CategoriasService
	def self.model() ::Categoria; end

	def self.index(params)
		list = Categoria.All
	end

	def self.create(novaCategoria)
		categoria = model.new(novaCategoria)

		return [:sucess, {categoria: categoria}] if categoria.save
		[:error, categoria.errors.full_messages]
	end

#	def self.destroy(novaCategoria)
#		categoria = Categoria.find(params[:id])
#		categoria.destroy
#	end
end
