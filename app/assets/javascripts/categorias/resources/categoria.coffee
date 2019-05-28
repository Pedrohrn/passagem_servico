angular.module('scApp').lazy
.factory 'Categoria', [
	'$resource'
	($resource)->

		$resource 'http://localhost:3000/categorias/:id.json', { id: '@id' },
			list:
				method: 'GET'

			create:
				method: 'POST'

			destroy:
				method: 'DELETE'

]
