angular.module('scApp').lazy
.controller 'PassagemServicos::IndexCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates', 'PassagemServico', 'Categoria'
	(scModal, scAlert, scToggle, scTopMessages, Templates, PassagemServico, Categoria)->
		vm = this
		vm.templates = Templates

		vm.init = ->
			vm.filtroCtrl.exec()

		vm.permissoesCtrl =
			list: [
				{ id: 1, label: 'Editar itens', value: false }
				{ id: 2, label: 'Editar categorias dos objetos', value: false }
				{ id: 3, label: 'Editar itens e categorias dos objetos', value: false }
				{ id: 4, label: 'Adicionar/Excluir itens', value: false }
				{ id: 5, label: 'Adicionar/Excluir objetos', value: false }
			]

		vm.filtroCtrl =
			fitroAvancado: false,

			showFilter: ->
				@filtroAvancado = !@filtroAvancado

			exec: ->
				vm.listCtrl.loadList()

		vm.porteirosCtrl =
			list: []

		vm.listCtrl =
			list: []

			#pagination: new scPagination

			reset: ->
				@list = []
				#@pagination.reset()

			loadList: ->
				return if @loading

				@reset()
				@exec()

			exec: (params)->
				return if @loading
				@loading = true

				params =
					filtro: vm.filtroCtrl.params
					#params.pagination = @pagination.next()

				PassagemServico.list params,
					(data)=>
						# success
						@loading = false
						@list.addOrExtend item for item in data.list
						vm.porteirosCtrl.list.addOrExtend item for item in data.pessoas
						vm.categoriasCtrl.list.addOrExtend item for item in data.categorias
					(response)=>
						# error
						@loading = false

		vm.novaPassagemCtrl =
			new: false

			newRecord: ->
				unless @new
					@new = true
					return

				scAlert.open
					title: 'Atenção!',
					messages: [
						{ msg: 'Tem certeza de que deseja fechar o formulário? Dados não salvos serão perdidos.'}
					],
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.novaPassagemCtrl.new = false },
						{ label: 'Não', color: 'gray' }
					]

		vm.itemCtrl =
			duplicata: false,
			params: {},

			init: (passagem)->
				passagem.menu = new scToggle()
				passagem.edit = new scToggle()
				passagem.acc = new scToggle()
				passagem.modal = new scModal()
				passagem.status = if passagem.status == 'Pendente' || 'pendente' then {color: 'yellow', label: 'Pendente'} else {color: 'green', label: 'Realizada'}

			editar: (passagem)->
				passagem.edit.open()

			accToggle: (passagem)->
				passagem.acc.toggle() unless passagem.edit && passagem.edit.opened
				vm.formCtrl.cancelar passagem, ->
				  passagem.acc.toggle()
				PassagemServico.show(passagem)

			duplicar: (passagem)->
				@duplicata = true;
				vm.novaPassagemCtrl.new = true;
				vm.itemCtrl.params = angular.copy(passagem)

			rmv: (passagem)->
				scAlert.open
					title: 'Atenção!',
					messages: [
						{ msg: 'Deseja realmente excluir este registro? Os dados não poderão ser recuperados após à exclusão.' }
					],
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.listCtrl.list.splice(passagem.id-1, 1); PassagemServico.destroy(passagem) },
						{ label: 'Cancelar', color: 'gray' }
					]

			disable: (passagem)->
				label = if passagem.disabled then 'restaurar' else 'cancelar'

				scAlert.open
					title: "Deseja #{label} a passagem?",
					buttons: [
						{ label: 'Não', color: 'gray' }
						{
							label: 'Sim'
							color: 'yellow'
							action: ->
								if passagem.disabled
									passagem.disabled = false
									passagem.status = { color: 'yellow', label: 'Pendente' }
								else
									passagem.disabled = true;
									passagem.status = {color: 'red', label: 'Desativada'}

						},
					],

		vm.topToolBar =
			menuIsVisible: false,

			toggle: ->
				@menuIsVisible = !@menuIsVisible

		vm.formCtrl =
			cancelar: (passagem)->
				if vm.novaPassagemCtrl.new
					vm.novaPassagemCtrl.newRecord()
				else if passagem.edit.opened
					scAlert.open
						title: 'Atenção!',
						messages: [
							{ msg: 'Deseja realmente cancelar a edição? Os dados não salvos serão perdidos.'}
						],
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> passagem.edit.toggle() ; passagem.acc.toggle() },
							{ label: 'Não', color: 'gray'}
						]

		vm.categoriasCtrl =
			list: [],
			edit: false,
			novaCategoria: {},
			toolbarIsShown: false,
			new: false,

			newCategoria: ->
				if vm.categoriasCtrl.new
					scAlert.open
						title: 'Deseja cancelar a edição? Dados não salvos serão perdidos.',
						buttons: [
							{	label: 'Sim', color: 'yellow', action: -> vm.categoriasCtrl.new = false }
						]
				else
					vm.categoriasCtrl.new = true

			init: (categoria)->
				categoria.edit = new scToggle()
				categoria.menu = new scToggle()

			desativar: (categoria)->
				label = if categoria.desativada then 'reativar' else 'desativar'

				scAlert.open
					title: "Deseja #{label} a categoria?",
					buttons: [
					  { label: 'Sim', color: 'yellow', action: -> categoria.desativada = !categoria.desativada },
					  { label: 'Não', color: 'gray' }
					]

			editar: (categoria)->
				if categoria.edit || vm.categoriasCtrl.new
					scAlert.open
						title: 'Deseja cancelar a edição?',
						buttons: [
						  { label: 'Sim', color: 'yellow', action: -> categoria.edit = false },
						  { label: 'Não', color: 'gray'}
						]
				else
					categoria.edit = true
					vm.categoriasCtrl.new_categoria = angular.copy(categoria.categoria.nome)

			rmv: (categoria)->
				scAlert.open
					title: 'Atenção!',
					messages: [
						{ msg: 'Deseja realmente excluir essa categoria? As passagens antigas não serão afetadas, mas os perfis que usam essa categoria não a terão mais em seus objetos.' }
					],
					buttons: [
						{ label: 'Excluir', color: 'red', action: -> vm.categoriasCtrl.list.splice(categoria.id-1, 1); Categoria.destroy(categoria) },
						{ label: 'Cancelar', color: 'gray'}
					]

			salvar: ->
				vm.categoriasCtrl.list.push
					id: vm.categoriasCtrl.list.length+1
					categoria: vm.categoriasCtrl.new_categoria

			toggleToolbar: (objeto)->
				objeto.toolbarIsShown = !objeto.toolbarIsShown

			submit: ->
				Categoria.create(vm.categoriasCtrl.novaCategoria)
				console.log(vm.categoriasCtrl.novaCategoria)

		vm.perfilCtrl =
			list: [
				{
					id: 1,
					nome: 'Perfil Teste',
					objetos: [
						{
							categoria: { id: 1, label: 'Funcionamento'},
							itens: [
								{ qtd: 1, label: 'teste' },
								{ qtd: 32, label: 'ui ui'}
							]
						},
						{
							categoria: { id: 2, label: 'Acontecimento'},
							itens: [
							  { qtd: 2, label: 'teste2' },
							  { qtd: 3, label: 'teste 234'}
							]
						}
					],
					disabled: false,
				},
				{
					id: 2,
					nome: 'Perfil Teste 2',
					objetos: [
						{
							categoria: { id: 1, label: 'Funcionamento'},
							itens: [
								{ qtd: 4, label: 'testessss' },
								{ qtd: 33, label: 'uissss ui'}
							]
						},
						{
							categoria: { id: 2, label: 'Acontecimento'},
							itens: [
							  { qtd: 8, label: 'teste2sss' },
							  { qtd: 9, label: 'testadase 234'}
							]
						}
					],
					disabled: false,
				},
			],
			modal: new scModal(),
			viewPerfis: true,
			viewCategorias: false,
			viewPermissoes: false,
			duplicata: false,
			menuIsShow: false,
			newPerfil: false,
			params: {},
			isCreating: false,

			init: (perfil)->
				perfil.edit = new scToggle()

			novoPerfil: ->
				if @newPerfil
					scAlert.open({
						title: 'Atenção!',
						messages: [
							{ msg: 'Deseja realmente fechar o formulário? Os dados não salvos serão perdidos.'},
						],
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.perfilCtrl.newPerfil = false; vm.perfilCtrl.isCreating = false },
							{ label: 'Não', color: 'gray'}
						]
					})
				else
					@newPerfil = true
					@isCreating = true
					@params = { objetos: []}

			modalToggle: ->
				@modal.open()

			close: ->
				@modal.close()

			addObjeto: ->
				vm.perfilCtrl.params.objetos.unshift(categoria: undefined, itens: [])

			rmvObjeto: (objeto)->
				vm.perfilCtrl.params.objetos.remove(objeto)

			addItem: (objetos)->
				objetos.itens.unshift( label: '', qtd: undefined )

			rmvItem: (objeto, item)->
				objeto.itens.remove(item)

			editar: (perfil)->
				if perfil.edit.opened
					vm.perfilCtrl.cancelar(perfil)
				else
					perfil.edit.opened = true
					@isCreating = true
					vm.perfilCtrl.params = angular.copy(perfil)

			showMenu: (perfil)->
				perfil.menuIsShow = !perfil.menuIsShow

			duplicar: (perfil)->
				@newPerfil = true
				@duplicata = true
				@isCreating = true
				vm.perfilCtrl.params = angular.copy(perfil)

			cancelar: (perfil)->
				if @newPerfil
					scAlert.open
						title: 'Atenção!',
						messages: [
						  { msg: 'Deseja realmente fechar o formulário? Dados não salvos serão perdidos.'}
						],
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> vm.perfilCtrl.newPerfil = false; vm.perfilCtrl.isCreating = false },
							{ label: 'Não', color: 'gray'}
						]
				else if perfil.edit && perfil.edit.opened
					scAlert.open
						title: 'Atenção!',
						messages: [
						  { msg: 'Deseja realmente fechar o formulário? Dados não salvos serão perdidos.'}
						],
						buttons: [
							{ label: 'Sim', color: 'yellow', action: -> perfil.edit.opened = false; vm.perfilCtrl.isCreating = false },
							{ label: 'Não', color: 'gray'}
						]
				else
					perfil.edit.toggle()
					vm.perfilCtrl.isCreating = true

			desativar: (perfil)->
				label = if perfil.disabled then 'reativar' else 'desativar'

				scAlert.open
					title: "Deseja realmente #{label} o perfil?",
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> perfil.disabled = !perfil.disabled },
						{ label: 'Não', color: 'gray' }
					]

			limparFormulario: ->
				scAlert.open
					title: 'Tem certeza que deseja limpar o formulário abaixo?',
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.perfilCtrl.params.objetos = [] },
						{ label: 'Não', color: 'gray'}
					]

			showCategorias: ->
				return unless (@viewCategorias == false && @viewPerfis == true || @viewPermissoes == true)
				@viewCategorias = true
				@viewPerfis = false
				@viewPermissoes = false

			showPermissoes: ->
				return unless (@viewPermissoes == false && @viewPerfis == true || @viewCategorias == true)
				@viewPermissoes = true
				@viewCategorias = false
				@viewPerfis = false

			showPerfis: ->
				return unless (@viewCategorias == true || @viewPermissoes == true && @viewPerfis == false)
				@viewPerfis = true
				@viewCategorias = false
				@viewPermissoes = false

		vm
]
