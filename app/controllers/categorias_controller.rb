class CategoriasController < ApplicationController
	def service() ::CategoriasService; end

	def index
		respond_to do |format|
			format.html{}
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
				end
			}
		end
	end

	def create
		st, resp = service.create(categoria_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
	end

	def destroy
		categoria = Categoria.find(params[:id])
		categoria.destroy
		#st, resp = service.create(categoria_params)

		#case st
		#when :success then render json: resp, status: :ok
		#when :error then render json: resp, status: :ok
		#end
	end

	def update
		st, resp = service.update(categoria_params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end

	end

	private

	def categoria_params
		attrs = [:id, :nome, :desativada]

		resp = params.require(:categoria).permit(attrs).to_h
		resp.deep_symbolize_keys
	end
end