class PerfisService
	def self.model() ::Perfil; end

	def self.index(params)
		list = Perfil.all
	end

	def self.show(params) #não vai ter show, na vdd
		perfil = model.find_by(id: params[:id])
		return [:not_found] if perfil.blank?
		[:success, perfil.to_frontend_obj]
	end

	def self.create(params)
		submit(params)
	end

	def self.update(params)
		submit(params)
	end

	def self.submit(params)
		params = set_objetos(params)
		perfil = model.find_by(id: params[:id]) || model.new
		perfil.assign_attributes(params)
		puts 'final params nigga'
		puts params

		return [:success, {perfil: perfil}] if perfil.save
		[:error, perfil.errors.full_messages]
		puts perfil
	end

	#private

	def self.set_objetos(params)
		objetos = params.delete(:objetos) || []
		return params if objetos.blank?

		params[:objetos_attributes] = objetos.map do |objeto|
			objeto[:categoria_id] = objeto.delete(:categoria)[:id]
			objeto
		end

		params
	end

end