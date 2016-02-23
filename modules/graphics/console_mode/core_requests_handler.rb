class CoreRequestsHandler
	def initialize
	end

	def execute(json_req)
		puts "-> #{json_req["data"]["name"]}"
	end
end
