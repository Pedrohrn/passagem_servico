class PassagemServicosService
	def self.index(params)
		[:success, { list: [] }]
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
	# 		return [:success, {passagem: passagem}]
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
