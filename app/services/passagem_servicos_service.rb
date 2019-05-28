class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index(params)
		list = model.buscar(params).map(&:slim_obj)

		[:success, { list: list, pessoas: Pessoa.all.limit(15), categorias: Categoria.all }] #aqui é onde se obtém as listas de pessoas e categorias
	end

	def self.show(params)
		passagem = model.find_by(id: params[:id])
		return [:not_found] if passagem.blank?
		[:success, passagem.to_frontend_obj]
	end

	def self.create(params)
		pessoa_saiu   = params.delete(:pessoa_saiu) || {}
		pessoa_entrou = params.delete(:pessoa_entrou) || {}

		params[:pessoa_saiu_id]   = pessoa_saiu[:id]
		params[:pessoa_entrou_id] = pessoa_entrou[:id]

	 	passagem = model.new(params)
	 	return [:success, {passagem_servico: passagem}] if passagem.save
 		[:error, passagem.errors.full_messages]
	end

	def self.edit(params)
	end

end
