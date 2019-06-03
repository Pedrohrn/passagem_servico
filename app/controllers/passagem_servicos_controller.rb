class PassagemServicosController < ApplicationController
	def service() ::PassagemServicosService; end

	def index
		respond_to do |format|
			format.html{ layout_erp }
			format.json{
				st, resp = service.index(get_params)

				case st
				when :success then render json: resp, status: :ok
				end
			}
		end
	end

	def show
		respond_to do |format|
			format.json{
				st, resp = service.show(get_params)

				case st
				when :success then render json: resp, status: :ok
				when :not_found then render json: resp, status: :not_found
				end
			}
		end

	end

	def create
		st, resp = service.create(passagem_service_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
	end

	def destroy
		passagem = PassagemServico.find_by(id: params[:id])
		passagem.destroy
	end

	def update
		st, resp = service.update(passagem_service_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
	end

	private

	def passagem_service_params
		attrs  = [:id, :observacoes, :status, :data]
		attrs << { pessoa_saiu: [:id] }
		attrs << { pessoa_entrou: [:id] }
		attrs << { perfil: [:id] }
		attrs << {
			objetos: [
				categoria: [:id], items: [:qtd, :label]
			],
		}

		resp = params.require(:passagem_servico).permit(attrs).to_h
		resp.deep_symbolize_keys

	end
end
