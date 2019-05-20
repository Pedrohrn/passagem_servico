class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	private

	def layout_erp
		render html: "", layout: "layouts/application"
	end

end
