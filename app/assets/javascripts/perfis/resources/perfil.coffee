angular.module('scApp').lazy
.factory 'Perfil', [
	'$resource'
	($resource)->
		encapsulateData = (data)-> JSON.stringify { perfil: data }

		$resource 'http://localhost:3000/perfis/:id.json', { id: '@id' },
			list:
				method: 'GET'

			show:
				method: 'GET'

			destroy:
				method: 'DELETE'

			create:
				method: 'POST'
				transformRequest: encapsulateData

			update:
				method: 'PUT'
				transformRequest: encapsulateData



]