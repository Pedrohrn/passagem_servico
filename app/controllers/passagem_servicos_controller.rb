class PassagemServicosController < ApplicationController

	def index
		respond_to do |format|
			format.html{ layout_erp }
			format.json{
				st, resp = ::PassagemServicosService.index(params)

				case st
				when :success then render json: resp, status: :ok
				end
			}
		end
	end

	def show
		st, resp = ::PassagemServicosService.show(params)

		case st
		when :success then render json: resp, status: :ok
		when :not_found then render json: resp, status: :not_found
		end
	end

	def create
		st, resp = ::PassagemServicosService.create(params)

		case st
		when :success then render json: resp, status: :ok
		when :error then render json: resp, status: :ok
		end
	end
end
