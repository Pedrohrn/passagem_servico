class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index(params)
		list = model.buscar(params).map(&:slim_obj)

		[:success, { list: list, pessoas: Pessoa.all.limit(15), categorias: Categoria.all, perfis: Perfil.all }] #aqui é onde se obtém as listas de pessoas e categorias
	end

	def self.show(params)
		passagem = model.find_by(id: params[:id]) || {}
		return [:not_found] if passagem.blank?
		[:success, passagem.to_frontend_obj]
	end

	def self.create(params)
		submit(params)
	end

	def self.update(params)
		submit(params)
	end

	def self.submit(params)
		pessoa_saiu   = params.delete(:pessoa_saiu) || {}
		pessoa_entrou = params.delete(:pessoa_entrou) || {}
		perfil = params.delete(:perfil) || {}

		params[:pessoa_saiu_id]   = pessoa_saiu[:id]
		params[:pessoa_entrou_id] = pessoa_entrou[:id]
		params[:perfil_id] = perfil[:id]

		puts 'entrada dos params'
		puts params
		params = set_objetos(params)
		puts 'params pos set_objetos'
		puts params

		passagem = model.find_by(id: params[:id]) || model.new
		passagem.assign_attributes(params)

		return [:success, {passagem_servico: passagem}] if passagem.save
		[:error, passagem.errors.full_messages]
	end

	#private

	def self.set_objetos(params)
		puts params
		objetos = params.delete(:objetos) || []
		puts params
		puts objetos
		return params if objetos.blank?

		params[:objetos_attributes] = objetos.map do |objeto|
			objeto[:categoria_id] = objeto.delete(:categoria)[:id]
			objeto
		end

		puts params

		params
	end

end
