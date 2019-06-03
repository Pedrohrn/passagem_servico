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
			pessoa_saiu: pessoa_obj(pessoa_saiu),
			pessoa_entrou: pessoa_obj(pessoa_entrou),
			data: created_at,
			status: status,
			observacoes: observacoes,
			objetos: objetos_obj,
			perfil: perfil_obj,
		}
	end

	def to_frontend_obj
		attrs = slim_obj
		attrs
	end

	def pessoa_obj(pessoa)
		{
			id: pessoa.id,
			nome: pessoa.nome,
		}
	end

	def objetos_obj
		objetos.map(&:to_frontend_obj)
	end

	def perfil_obj
		{
			id: perfil_id,
		}
	end

	private

end
