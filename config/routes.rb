Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'passagem_servicos#index'

  resources :passagem_servicos, only: [:index, :create, :show, :destroy, :update] #precisa liberar os métodos aqui
  resources :pessoas, only: [:index]
  resources :categorias, only: [:index, :create, :destroy, :update]
  resources :perfis, only: [:index, :create, :destroy, :update]
end
