class Item < ApplicationRecord
	validates_presence_of :nome, message: "Nome do item não pode ser vazio!"

end
