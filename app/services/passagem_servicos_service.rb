class PassagemServicosService
	def self.model() ::PassagemServico; end

	def self.index(params)
		list = model.all.map(&:slim_obj)

		# list = [
		# 	{
		# 		id: 1,
		# 		status: { label: 'Realizada', color: 'green' },
		# 		pessoa_saiu: { id: 1, nome: 'Porteiro 1' },
		# 		pessoa_entrou: { id: 2, nome: 'Porteiro 2'},
		# 		data_cadastro: '30042018',
		# 		data_passagem: '30042018',
		# 		perfil: { id: 1, nome: 'Perfil Teste' },
		# 		objetos: [
		# 			{
		# 				categoria: { id: 1, label: 'Funcionamento' },
		# 				itens: [
		# 				 	{ qtd: 1, label: 'teste' },
		# 				 	{ qtd: 13, label: 'teste2' },
		# 				],
		# 			},
		# 			{
		# 				categoria: { id: 2, label: 'Acontecimento' },
		# 				itens: [
		# 					{ qtd: 1, label: 'teste32' },
		# 					{ qtd: 2, label: 'teste223' }
		# 				]
		# 			}
		# 		],
		# 		disabled: false,
		# 		observacoes: 'blabdsakdsabdsa',
		# 		notificacoes: [
		# 			{
		# 				status: { label: 'Enviada', color: 'yellow' },
		# 				user: { name: 'Pedro Henrique', email: 'pedrohrnogueira@outlook.com' },
		# 				data_envio: '02032018',
		# 			},
		# 			{
		# 				status: { label: 'Lida', color: 'green' },
		# 				user: { name: 'Pedro Henrique', email: 'pedrohrnogueira@outlook.com' },
		# 				data_leitura: '03032018',
		# 			},
		# 		],
		# 	}
		# ]

		[:success, { list: list }]
	end

	def self.create(params)
		passagem = model.new
	end

	# def self.show(params)
	# 	passagem = model.find_by(id: params[:id])
	# 	return [:not_found] if passagem.blank?
	# 	[:success, passagem.to_obj]
	# end

	# def self.create(params)
	# 	passagem = model.new

	# 	params = (tratar params .........)

	# 	passagem.assign_attributes(params)
	# 	if passagem.save
	# 		return [:success, {passagem_servico: passagem}]
	# 	else
	# 		# return [:error, passagem.errors.full_messages]
	# 		return [:error, ['tituo nã pode ser vazio']]
	# 	end

	# 	errors = 'tem que ter titulo' if passagem.titutlo.blank?

	# 	passagem
	# 	passagem
	# 	passagem
	# 	passagem
	# 	passagem

	# 	set_entrou_id(params)
	# 		passagem.entrou_id = params[:entrou][:id]


	# 	if params[:kalals]
	# 		passaem.valor = passagem.items.map(&:valor).sum


	# 	passagem
	# 	passagem

	# 	passagem.save

	# 	avisar_gerentes_da_passagem(passagem)

	# 	case st
	# 	when :success then render json: resp, status: :ok
	# 	end
	# end
end
