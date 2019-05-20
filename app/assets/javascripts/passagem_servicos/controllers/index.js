angular.module('scApp').lazy

.controller( 'PassagemServicos::IndexCtrl', [ '$scModal', 'scAlert', 'scToggle', 'scTopMessages', 'Templates' , function(scModal, scAlert, scToggle, scTopMessages, Templates) {
	var vm = this;

	vm.templates = Templates

	vm.permissoesCtrl = {
		list: [
			{ id: 1, label: 'Editar itens', value: false },
			{ id: 2, label: 'Editar categorias dos objetos', value: false },
			{ id: 3, label: 'Editar itens e categorias dos objetos', value: false },
			{ id: 4, label: 'Adicionar/Excluir itens', value: false },
			{ id: 5, label: 'Adicionar/Excluir objetos', value: false },
		],
	};

	vm.listCtrl = {
		list: [
			{ id: 1,
				status: { label: 'Realizada', color: 'green' },
				pessoa_saiu: { id: 1, nome: 'Porteiro 1' },
				pessoa_entrou: { id: 2, nome: 'Porteiro 2'},
				data_cadastro: 30042018,
				data_passagem: 30042018,
				perfil: { id: 1, nome: 'Perfil Teste' },
				objetos: [
					{ categoria: { id: 1, label: 'Funcionamento' },
						itens: [
						 	{ qtd: 1, label: 'teste' },
						 	{ qtd: 13, label: 'teste2' },
						],
					},
					{ categoria: { id: 2, label: 'Acontecimento' },
						itens: [
							{ qtd: 1, label: 'teste32' },
							{ qtd: 2, label: 'teste223' }
						]
					}
				],
				disabled: false,
				observacoes: 'blabdsakdsabdsa',
				notificacoes: [
					{	status: { label: 'Enviada', color: 'yellow' },
						user: { name: 'Pedro Henrique', email: 'pedrohrnogueira@outlook.com' },
						data_envio: 02032018,
					},
					{ status: { label: 'Lida', color: 'green' },
						user: { name: 'Pedro Henrique', email: 'pedrohrnogueira@outlook.com' },
						data_leitura: 03032018,
					},
				],
			}
		]
	};

	vm.novaPassagemCtrl = {
		new: false,

		newRecord: function() {
			if (this.new) {
				scAlert.open({
					title: 'Atenção!',
					messages: [
						{ msg: 'Tem certeza de que deseja fechar o formulário? Dados não salvos serão perdidos.'}
					],
					buttons: [
						{ label: 'Sim', color: 'yellow', action: function() { vm.novaPassagemCtrl.new = false } },
						{ label: 'Não', color: 'gray' }
					]
				})
			} else {
				this.new = true
			}
		},
	}

	vm.itemCtrl = {
		duplicata: false,

		init: function(passagem){
			passagem.menu = new scToggle()
			passagem.edit = new scToggle()
			passagem.acc = new scToggle()
			passagem.modal = new scModal()
		},

		editar: function(passagem) {
			if (passagem.edit && passagem.edit.opened) {
				scAlert.open({
					title: 'Atenção!',
					messages: [
 						{ msg: 'Deseja realmente fechar o formulário? Alterações não salvas serão perdidas.'}
					],
					buttons: [
						{ label: 'Sim', color: 'yellow', action: function() { passagem.edit.close(); passagem.acc.open() } },
						{ label: 'Não', color: 'gray'}
					]
				})
			} else {
				passagem.edit.open()
				passagem.acc.close()
			}
		},

		accToggle: function(passagem) {
			if (passagem.edit && passagem.edit.opened) {
				return vm.formCtrl.cancelar(passagem, function() { passagem.acc.toggle() })
			} else {
				passagem.acc.toggle()
			}
		},

		duplicar: function(passagem) {
			this.duplicata = true;
			vm.novaPassagemCtrl.new = true;
			params = angular.copy(passagem)
		},

		rmv: function(passagem) {
			scAlert.open({
				title: 'Atenção!',
				messages: [
					{ msg: 'Deseja realmente excluir este registro? Os dados não poderão ser recuperados após à exclusão.' }
				],
				buttons: [
					{ label: 'Excluir', color: 'red', action: function() { vm.listCtrl.list.splice(passagem.id-1, 1) } },
					{ label: 'Cancelar', color: 'gray' }
				]
			})
		},

		disable: function(passagem) {
			title: ''
			if (!passagem.disabled){
				this.title = 'Deseja cancelar a passagem?'
			} else {
				this.title = 'Deseja restaurar a passagem?'
			}
			scAlert.open({
				title: this.title,
				buttons: [
					{ label: 'Sim',
						color: 'yellow',
						action: function() {
							if (passagem.disabled) {
								passagem.disabled = false;
					 			passagem.status = { color: 'yellow', label: 'Pendente'}
					 		} else {
					 			passagem.disabled = true;
					 			passagem.status = {color: 'red', label: 'Desativada'}
					 		}
					 	}
					},
					{ label: 'Não',
						color: 'gray'
					}
				],
			})
		}

	};

	vm.topToolBar = {
		menuIsVisible: false,

		toggle: function() {
			this.menuIsVisible = !this.menuIsVisible
		},
	};

	vm.formCtrl = {
		cancelar: function(passagem) {
			if (vm.novaPassagemCtrl.new) {
				return vm.novaPassagemCtrl.newRecord()
			} else if (passagem.edit.opened) {
				scAlert.open({
					title: 'Atenção!',
					messages: [
						{ msg: 'Deseja realmente cancelar a edição? Os dados não salvos serão perdidos.'}
					],
					buttons: [
						{ label: 'Sim', color: 'yellow', action: function() { passagem.edit.toggle() ; passagem.acc.toggle() } },
						{ label: 'Não', color: 'gray'}
					]
				})
			}
		}
	}

	vm.filtroCtrl = {
		fitroAvancado: false,

		showFilter: function(){
			this.filtroAvancado = !this.filtroAvancado
		},
	};

	vm.categoriasCtrl = {
		list: [
			{ id: 1, label: 'Funcionamento', disabled: false },
			{ id: 2, label: 'Acontecimento', disabled: false },
			{ id: 3, label: 'Empréstimos', disabled: true },
		],
		edit: false,
		novaCategoria: '',
		menuIsShown: false,

		desativar: function(categoria) {
			title: '';
			if (categoria.disabled) {
				this.title = 'Deseja reativar a categoria?'
			} else {
				this.title = 'Deseja desativar a categoria?'
			}
			scAlert.open({
				title: this.title,
				buttons: [
				  { label: 'Sim', color: 'yellow', action: function() { categoria.disabled = !categoria.disabled } },
				  { label: 'Não', color: 'gray' }
				]
			})
		},

		editar: function(categoria) {
			if (categoria.edit) {
				scAlert.open({
					title: 'Deseja cancelar a edição?',
					buttons: [
					  { label: 'Sim', color: 'yellow', action: function() { categoria.edit = false } },
					  { label: 'Não', color: 'gray'}
					]
				})
			} else {
				categoria.edit = true
				this.novaCategoria = angular.copy(categoria.label)
			}
		},

		rmv: function(categoria) {
			scAlert.open({
				title: 'Atenção!',
				messages: [
					{ msg: 'Deseja realmente excluir essa categoria? As passagens antigas não serão afetadas, mas os perfis que usam essa categoria não a terão mais em seus objetos.' }
				],
				buttons: [
					{ label: 'Excluir', color: 'red', action: function() { vm.categoriasCtrl.list.splice(categoria.id-1, 1) } },
					{ label: 'Cancelar', color: 'gray'}
				]
			})
		},

		salvar: function(categoria) {
			categoria = categoria || {};

		},

		showMenu: function(categoria) {
			categoria.menuIsShown = !categoria.menuIsShown
		},
	};

	vm.perfilCtrl = {
		list: [
			{ id: 1,
				nome: 'Perfil Teste',
				objetos: [
					{ categoria: { id: 1, label: 'Funcionamento'},
						itens: [
							{ qtd: 1, label: 'teste' },
							{ qtd: 32, label: 'ui ui'}
						]
					},
					{ categoria: { id: 2, label: 'Acontecimento'},
						itens: [
						  { qtd: 2, label: 'teste2' },
						  { qtd: 3, label: 'teste 234'}
						]
					}
				],
				disabled: false,
			},
			{ id: 2,
				nome: 'Perfil Teste 2',
				objetos: [
					{ categoria: { id: 1, label: 'Funcionamento'},
						itens: [
							{ qtd: 4, label: 'testessss' },
							{ qtd: 33, label: 'uissss ui'}
						]
					},
					{ categoria: { id: 2, label: 'Acontecimento'},
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

		init: function(perfil) {
			perfil.edit = new scToggle()
		},

		formInit: function(perfil) {
			if (this.newPerfil && !this.duplicata) {
				perfil = { objetos: [] }
				console.log(perfil)
			} else if (this.newPerfil && this.duplicata) {
				console.log(perfil)
				vm.perfilCtrl.params = angular.copy(perfil)
				console.log(vm.perfilCtrl.params)
			}
		},

		novoPerfil: function() {
			if (this.newPerfil == false) {
				this.newPerfil = true
			} else {
				scAlert.open({
					title: 'Atenção!',
					messages: [
						{ msg: 'Deseja realmente fechar o formulário? Os dados não salvos serão perdidos.'},
					],
					buttons: [
						{ label: 'Sim', color: 'yellow', action: function() { vm.perfilCtrl.newPerfil = false } },
						{ label: 'Não', color: 'gray'}
					]
				})
			}
		},

		modalToggle: function() {
			this.modal.open()
		},

		close: function() {
			this.modal.close()
		},

		editar: function(perfil) {
			if (perfil.edit.opened) {
				return vm.perfilCtrl.cancelar(perfil)
			} else {
				perfil.edit.opened = true
			}
		},

		showMenu: function(perfil){
			perfil.menuIsShow = !perfil.menuIsShow
		},

		duplicar: function(perfil) {
			this.duplicata = true
			this.newPerfil = true
			vm.perfilCtrl.params = angular.copy(perfil)
			console.log(vm.perfilCtrl.params)
		},

		cancelar: function(perfil) {
			if (perfil.edit && perfil.edit.opened) {
				scAlert.open({
					title: 'Atenção!',
					messages: [
					  { msg: 'Deseja realmente fechar o formulário? Dados não salvos serão perdidos.'}
					],
					buttons: [
						{ label: 'Sim', color: 'yellow', action: function() { perfil.edit.opened = false; } },
						{ label: 'Não', color: 'gray'}
					]
				})
			} else if (this.newPerfil) {
				scAlert.open({
					title: 'Atenção!',
					messages: [
					  { msg: 'Deseja realmente fechar o formulário? Dados não salvos serão perdidos.'}
					],
					buttons: [
						{ label: 'Sim', color: 'yellow', action: function() { vm.perfilCtrl.newPerfil = false; } },
						{ label: 'Não', color: 'gray'}
					]
				})
			} else {
				perfil.edit.toggle()
			}
		},

		desativar: function(perfil) {
			title: '';
			if (perfil.disabled) {
				this.title = 'Deseja reativar o perfil?'
			} else {
				this.title = 'Deseja realmente desativar o perfil?'
			}
			scAlert.open({
				title: this.title,
				buttons: [
					{ label: 'Sim', color: 'yellow', action: function() { perfil.disabled = !perfil.disabled } },
					{ label: 'Não', color: 'gray' }
				]
			})
		},

		showCategorias: function() {
			if (this.viewCategorias == false && this.viewPerfis == true || this.viewPermissoes == true) {
				this.viewCategorias = true
				this.viewPerfis = false
				this.viewPermissoes = false
			}
		},

		showPermissoes: function() {
			if (this.viewPermissoes == false && this.viewPerfis == true || this.viewCategorias == true) {
				this.viewPermissoes = true
				this.viewCategorias = false
				this.viewPerfis = false
			}
		},

		showPerfis: function() {
			if (this.viewCategorias == true || this.viewPermissoes == true && this.viewPerfis == false) {
				this.viewPerfis = true
				this.viewCategorias = false
				this.viewPermissoes = false
			}
		},
	};

}])