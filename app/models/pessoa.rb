class Pessoa < ApplicationRecord
	validates_presence_of :nome, message: "Nome deve ser preenchido!"

	has_many :passagem_servicos, foreign_key: 'pessoa_entrou_id'
	has_many :passagem_servicos, foreign_key: 'pessoa_saiu_id'
end
