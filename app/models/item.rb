class Item < ApplicationRecord
	validates_presence_of :nome, message: "Nome do item não pode ser vazio!"
	validates_numericality_of :qtd, message: "Entre com uma quantidade válida!"

end
