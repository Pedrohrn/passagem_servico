angular.module('scApp').lazy

.controller( 'PassagemServicos::FormCtrl', [ '$scModal', 'scAlert', 'scToggle', function(scModal, scAlert, scToggle) {
	vm = this;

	vm.new = false;
	vm.params = {};
	vm.listCtrl = null;
	vm.passagem = null;
	vm.itemCtrl = null;
	vm.formularioCtrl = null;

	vm.init = function(passagem, listCtrl, itemCtrl, formularioCtrl){
		vm.passagem = passagem
		vm.itemCtrl = itemCtrl
		vm.formularioCtrl = formularioCtrl

		vm.params = angular.copy(passagem || {});
		if (Object.blank(passagem)) {
			vm.formCtrl.current_perfil = undefined
		} else {
			vm.formCtrl.current_perfil = angular.copy(passagem.perfil)
		}
		vm.listCtrl = listCtrl

		if (Object.blank(vm.params)) {
			vm.params.objetos = [];
			vm.params.current_perfil = undefined;
			vm.new = true;
		};

/*		if (vm.itemCtrl.duplicata) {
			vm.params = angular.copy(vm.itemCtrl.params)
		};*/

	};

	vm.formCtrl = {
		setPerfil: function() {
			scAlert.open({
				title: 'Atenção!',
				messages: [
					{ msg: 'O perfil de passagem foi alterado. O que deseja fazer com os objetos?'},
					{ msg: 'Observação: Objetos sem categoria definida serão automaticamente excluídos.'}
				],
				buttons: [
					{ label: 'Mesclar', tooltip: 'Mescla os itens, por categoria, do formulário abaixo com os itens do perfil selecionado', color: 'blue', action: function() {
							if (Object.blank(vm.params.objetos)) {
								console.log('1')
								for (var k = 0; k < vm.params.objetos.length; k++){
									if (vm.params.objetos[k].categoria == undefined || vm.params.objetos[k].categoria == {})
										vm.params.objetos.remove(vm.params.objetos[k])
								}
								vm.params.perfil = angular.copy(vm.formCtrl.current_perfil)
								vm.params.objetos = angular.copy(vm.params.perfil.objetos)
							} else if ( vm.params.perfil && !Object.blank(vm.params.objetos) ) {
								console.log('2')
								for (var k = 0; k < vm.params.objetos.length; k++){
									if (vm.params.objetos[k].categoria == undefined || vm.params.objetos[k].categoria == {})
										vm.params.objetos.remove(vm.params.objetos[k])
								}
								vm.params.perfil = angular.copy(vm.formCtrl.current_perfil)
								var menor = undefined
								var maior = undefined
								if (vm.params.objetos.length >= vm.params.perfil.objetos.length) {
									maior = vm.params.objetos
									menor = vm.params.perfil.objetos
								} else {
									menor = vm.params.objetos
									maior = vm.params.perfil.objetos
								}
								for (var i = 0; i < maior.length; i++) {
									for (var j = 0; j < menor.length; j++) {
										if (vm.params.objetos[i].categoria.label == vm.params.perfil.objetos[j].categoria.label) {
											vm.params.objetos[i].itens = vm.params.objetos[i].itens.concat(vm.params.perfil.objetos[j].itens)
											vm.params.perfil.objetos.remove(vm.params.perfil.objetos[j])
										}
									}
								}
								vm.params.objetos = vm.params.objetos.concat(vm.params.perfil.objetos)
							} else if (vm.params.objetos.length > 0 && Object.blank(vm.params.perfil)) {
								console.log('3')
								for (var k = 0; k < vm.params.objetos.length; k++){
									if (vm.params.objetos[k].categoria == undefined || vm.params.objetos[k].categoria == {})
										vm.params.objetos.remove(vm.params.objetos[k])
								}
								var aux = angular.copy(vm.params.objetos);
								vm.params.objetos = [];
								console.log(aux)
								console.log(vm.params.objetos)
								for (i = 0; i < aux.length; i ++) {
									if (aux[i].categoria != null && aux[i].categoria != undefined && aux[i].categoria != {}) {
										vm.params.objetos.push(aux[i])
									}
								}
								console.log(aux)
								console.log(vm.params.objetos)
								vm.params.perfil = angular.copy(vm.formCtrl.current_perfil)
								var menor = undefined
								var maior = undefined
								if (vm.params.objetos.length >= vm.params.perfil.objetos.length) {
									maior = vm.params.objetos
									menor = vm.params.perfil.objetos
								} else {
									menor = vm.params.objetos
									maior = vm.params.perfil.objetos
								}
								for (var i = 0; i < maior.length; i++) {
									for (var j = 0; j < menor.length; j++) {
										if (vm.params.objetos[i].categoria.label == vm.params.perfil.objetos[j].categoria.label) {
											vm.params.objetos[i].itens = vm.params.objetos[i].itens.concat(vm.params.perfil.objetos[j].itens)
											vm.params.perfil.objetos.remove(vm.params.perfil.objetos[j])
										}
									}
								}
								vm.params.objetos = vm.params.objetos.concat(vm.params.perfil.objetos)
							}
						}
					},
					{ label: 'Sobreescrever', tooltip: 'Sobreescreve os objetos abaixo pelos objetos do perfil selecionado', color: 'yellow', action: function() {
							vm.params.perfil = angular.copy(vm.formCtrl.current_perfil)
							vm.params.objetos = angular.copy(vm.params.perfil.objetos)
						},
					},
					{ label: 'Cancelar', color: 'gray', action: function() { scAlert.close() ; vm.params.perfil = [] } }
				]
			})
		},

		limparForm: function() {
			scAlert.open({
				title: 'Deseja realmente limpar o formulário abaixo?',
				buttons: [
					{ label: 'Sim', color: 'yellow', action: function() { vm.params.objetos = [] } },
					{ label: 'Não', color: 'gray' }
				]
			})
		},

	};

	vm.objetosCtrl = {
		setCategoria: function(objeto) {
			var count = 0;
			for (var i = 0; i < vm.params.objetos.length; i ++) {
				if (Object.blank(vm.params.objetos[i].categoria) || vm.params.objetos[i].categoria == undefined) {
				} else if (vm.params.objetos[i].categoria.label == objeto.categoria.label) {
					count++;
				}
			};
			if (count >= 2) {
				scAlert.open({
					title: 'A categoria selecionada já existe na lista! Selecione outra!',
					buttons: [
						{ label: 'Ok', color: 'gray' }
					]
				})
				objeto.categoria = {}
				count = 1
			}
		},

		addObjeto: function() {
			vm.params.objetos.unshift({ categoria: undefined, itens: [], id: vm.params.objetos.length+1 })
		},

		rmvObjeto: function(objeto) {
			vm.params.objetos.remove(objeto)
		},

		addItem: function(objeto){
			objeto.itens.push({ qtd: undefined, label: '' })
		},

		rmvItem: function(objeto, item){
			objeto.itens.remove(item)
		},
	};

}])