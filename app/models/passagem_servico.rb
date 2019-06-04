class PassagemServico < ApplicationRecord
	validates_presence_of :pessoa_entrou_id, message: "Selecione a pessoa que está entrando!"
	validates_presence_of :pessoa_saiu_id, message: "Selecione a pessoa que está saindo!"
	validates_presence_of :status

	belongs_to :pessoa_saiu, class_name: 'Pessoa'
	belongs_to :pessoa_entrou, class_name: 'Pessoa'
	has_many :objetos

	accepts_nested_attributes_for :objetos

	scope :buscar, lambda { |params|
		filtro = (params[:filtro] || {}).deep_symbolize_keys

		scoped = all

		scoped.busca_simples(filtro[:q])
	}

	scope :busca_simples, lambda { |q|
		scoped = all

		sql = 'pessoas.nome LIKE :nome OR pessoa_entrous_passagem_servicos.nome LIKE :nome'

		joins(:pessoa_saiu, :pessoa_entrou).where(sql, nome: "%#{q}%")
	}

	def slim_obj
		{
			id: id,
			pessoa_saiu: pessoa_saiu.to_frontend_obj,
			pessoa_entrou: pessoa_entrou.to_frontend_obj,
			data: created_at,
			status: status,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs[:objetos] = objetos_obj
		attrs[:observacoes] = observacoes
		attrs
	end

	def objetos_obj
		objetos.map(&:to_frontend_obj)
	end

	private

end
