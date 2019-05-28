angular.module('scApp').lazy
.factory 'PassagemServico', [
	'$resource'
	($resource)->
		encapsulateData = (data)-> JSON.stringify { passagem_servico: data }

		$resource 'http://localhost:3000/passagem_servicos/:id.json', { id: '@id' },
			list:
				method: 'GET'

			show:
				method: 'GET'

			create:
				method: 'POST'
				transformRequest: encapsulateData

			destroy:
				method: 'DELETE'

			edit:
				method: 'GET'

			update:
				method: 'PUT'

]
