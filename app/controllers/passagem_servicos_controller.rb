class PassagemServicosController < ApplicationController
	def service() ::PassagemServicosService; end

	def index
		respond_to do |format|
			format.html{ layout_erp }
			format.json{
				st, resp = service.index(params)

				case st
				when :success then render json: resp, status: :ok
				end
			}
		end
	end

	def show
		st, resp = service.show(params)

		case st
		when :success then render json: resp, status: :ok
		when :not_found then render json: resp, status: :not_found
		end
	end

	def create
		st, resp = service.create(params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
	end
end
