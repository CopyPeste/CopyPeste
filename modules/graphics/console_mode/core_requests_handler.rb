class CoreRequestsHandler
	def initialize
	end

	def execute(json_req)
		puts "-> #{json_req["test"]}"
	end
end