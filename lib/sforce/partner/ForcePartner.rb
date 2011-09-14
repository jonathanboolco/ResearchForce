class ForcePartner

	def initialize(username,password,token)
		
		@username = username
		@password = password+''+token

	end

  	def login

	  	partner = partnerAPIClient

	  	#for some reason I need to this, otherwise I get nil values in the string concatenation
	  	uname = @username
	  	pwd = @password

	  	response = partner.request :login do
	  		soap.body = '<username>'+uname+'</username><password>'+pwd+'</password>'
	  	end

	  	return response.to_hash
  	end

	private

	    def partnerAPIClient
		  	client = Savon::Client.new do
		  		wsdl.document = File.expand_path("../../../wsdls/partner.wsdl", __FILE__)
			end
			
			puts 'partner Client actions : '
			puts client.wsdl.soap_actions

			return client
	    end

end