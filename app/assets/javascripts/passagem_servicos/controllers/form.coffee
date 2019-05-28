angular.module('scApp').lazy

.controller 'PassagemServicos::FormCtrl', [
	'$scModal', 'scAlert', 'scToggle', 'PassagemServico',
	(scModal, scAlert, scToggle, PassagemServico)->
		vm = this

		vm.new = false
		vm.params = {}
		vm.listCtrl = null
		vm.passagem = null
		vm.itemCtrl = null
		vm.formularioCtrl = null

		vm.init = (passagem)->
			vm.passagem = passagem

			vm.params = angular.copy(passagem || {});
			vm.formCtrl.current_perfil = if Object.blank(passagem) then undefined else angular.copy(passagem.perfil)

			return unless Object.blank(vm.params)
			vm.params.objetos = [];
			vm.params.current_perfil = undefined;
			vm.new = true;

		vm.formCtrl =
			setPerfil: ->
				scAlert.open
					title: 'Atenção!',
					messages: [
						{ msg: 'O perfil de passagem foi alterado. O que deseja fazer com os objetos?'},
						{ msg: 'Observação: Objetos sem categoria definida serão automaticamente excluídos.'}
					],
					buttons: [
						{
							label: 'Cancelar',
							color: 'gray',
							action: ->
								vm.formCtrl.cancelar()						}
						{
							label: 'Mesclar'
							tooltip: 'Mescla os itens, por categoria, do formulário abaixo com os itens do perfil selecionado'
							color: 'blue'
							action: ->
								return vm.formCtrl.sobreescreverObjetos() if Object.blank(vm.params.objetos)
								vm.formCtrl.mesclarObjetos()
						}
						{
							label: 'Sobreescrever'
							tooltip: 'Sobreescreve os objetos abaixo pelos objetos do perfil selecionado'
							color: 'yellow'
							action: ->
								vm.formCtrl.sobreescreverObjetos()
						}
					]

			cancelar: ->
				vm.formCtrl.current_perfil = if Object.blank(vm.params.perfil) then {} else vm.params.perfil

			salvar: ->
				vm.formCtrl.params

			salvar_e_passar: ->
				vm.formCtrl.params

			mesclarObjetos: ->
				# garantindo objetos com categorias
				listRemove = []
				listRemove.push(item) for item in vm.params.objetos when Object.blank(item.categoria)

				vm.params.objetos.remove(item) for item in listRemove

				# Mesclando objetos do perfil
				vm.params.perfil = angular.copy(vm.formCtrl.current_perfil)
				for perfilObjeto in vm.params.perfil.objetos
					paramsObjeto = vm.params.objetos.find (el)-> el.categoria.id == perfilObjeto.categoria.id
					if paramsObjeto
						paramsObjeto.itens = paramsObjeto.itens.concat(perfilObjeto.itens)
					else
						vm.params.objetos.push(perfilObjeto)

			sobreescreverObjetos: ->
				vm.params.perfil  = angular.copy(vm.formCtrl.current_perfil)
				vm.params.objetos = angular.copy(vm.params.perfil.objetos)

			limparForm: ->
				scAlert.open
					title: 'Deseja realmente limpar o formulário abaixo?',
					buttons: [
						{ label: 'Sim', color: 'yellow', action: -> vm.params.objetos = [] },
						{ label: 'Não', color: 'gray' }
					]

		vm.objetosCtrl =
			setCategoria: (objeto)->
				count = 0;
				for item in vm.params.objetos
					continue unless item.categoria?.nome == objeto.categoria?.nome
					count++;

				return unless count >= 2

				scAlert.open
					title: 'A categoria selecionada já existe na lista! Selecione outra!',
					buttons: [
						{ label: 'Ok', color: 'gray' }
					]

				objeto.categoria = {}

			addObjeto: ->
				vm.params.objetos.unshift( categoria: undefined, itens: [], id: vm.params.objetos.length+1 )

			rmvObjeto: (objeto)->
				vm.params.objetos.remove(objeto)

			addItem: (objeto)->
				objeto.itens.push( qtd: undefined, label: '' )

			rmvItem: (objeto, item)->
				objeto.itens.remove(item)

		vm.submit = ->
			PassagemServico.create(vm.params)
			console.log(vm.params)

		vm
]