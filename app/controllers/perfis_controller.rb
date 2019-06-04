class PerfisController < ApplicationController
	def service() ::PerfisService; end

	def index
		st, resp = service.index(get_params)

		case st
		when :success then render json: resp, status: :ok
		end
	end

	def show
		respond_to do |format|
			format.json{
				st, resp = service.show(get_params)

				case st
				when :success then render json: resp, status: :ok
				when :not_found then render json: resp, status: :ok
				end
			}
		end
	end

	def create
		st, resp = service.create(perfil_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
		puts st
		puts resp
	end

	def destroy
		perfil = Perfil.find_by(id: params[:id])
		perfil.del_obj
		perfil.destroy
	end

	def update
		st, resp = service.update(perfil_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
	end

	private

	def perfil_params
		attrs = [:id, :nome, :desativado]
		attrs << {
			objetos: [
				categoria: [:id], items: [:qtd, :label]
			],
		}

		resp = params.require(:perfil).permit(attrs).to_h
		resp.deep_symbolize_keys

	end

	def del_obj
		objetos = perfil.delete(:objetos)
		for objeto in objetos
			objeto = Objeto.find_by(id: objeto[:id])
			objeto.destroy
		end
	end

end