require 'sforce/partner/ForcePartner'

class ForceMetadata

	def initialize(username,password,token)
		
		@username = username
		@password = password
		@token = token
		@sessionId = ''
		@metadataServerURL = ''

	end

	def listObjects(folder,type,asOfVersion)

		metadata = metadataAPIClient

		response = metadata.request :list_metadata do
			sbody = '<ns2:listMetadata xmlns:ns2="http://soap.sforce.com/2006/04/metadata"><queries><folder>'+folder+'</folder><type>'+type+'</type></queries><asOfVersion>'+asOfVersion.to_s+'</asOfVersion></ns2:listMetadata>'
			soap.xml = setXML(sbody)
		end

		puts response
		return response

	end

	def describeMetadata(asOfVersion)

		metadata = metadataAPIClient

		response = metadata.request :describe_metadata do
			sbody = '<ns2:describeMetadata xmlns:ns2="http://soap.sforce.com/2006/04/metadata"><asOfVersion>'+asOfVersion.to_s+'</asOfVersion></ns2:describeMetadata>'
			soap.xml = setXML(sbody)
		end

		puts response
		return response

	end


	def create(metadataDef)
	
		metadata = metadataAPIClient

		response = metadata.request :describe_metadata do
			sbody = '<create xmlns="http://soap.sforce.com/2006/04/metadata">'+metadataDef+'</create>'
			#sbody = '<create xmlns="http://soap.sforce.com/2006/04/metadata"><metadata xsi:type="ns2:CustomObject" xmlns:ns2="http://soap.sforce.com/2006/04/metadata"><fullName>Demo_Report_Object__c</fullName><deploymentStatus>Deployed</deploymentStatus><description>created by the Metadata API</description><enableActivities>true</enableActivities><label>Report Object</label><nameField><displayFormat>AN-{0000}</displayFormat><label>sample__c Name</label><type>AutoNumber</type></nameField><pluralLabel>sample Objects</pluralLabel><sharingModel>ReadWrite</sharingModel></metadata></create>'
			soap.xml = setXML(sbody)
		end

		puts response
		return response

	end


	def createCustomObject(customObject)
	
		metadata = metadataAPIClient

		response = metadata.request :create do
			sbody = '<create xmlns="http://soap.sforce.com/2006/04/metadata">'+customObject.getMetadata+'</create>'
			#sbody = '<create xmlns="http://soap.sforce.com/2006/04/metadata"><metadata xsi:type="ns2:CustomObject" xmlns:ns2="http://soap.sforce.com/2006/04/metadata"><fullName>Demo_Report_Object__c</fullName><deploymentStatus>Deployed</deploymentStatus><description>created by the Metadata API</description><enableActivities>true</enableActivities><label>Report Object</label><nameField><displayFormat>AN-{0000}</displayFormat><label>sample__c Name</label><type>AutoNumber</type></nameField><pluralLabel>sample Objects</pluralLabel><sharingModel>ReadWrite</sharingModel></metadata></create>'
			soap.xml = setXML(sbody)
		end

		puts response
		return response

	end

	def createCustomFields(lCustomFields)
	
		metadata = metadataAPIClient

		sFields = ''
		lCustomFields.each do |cf|
			sFields += cf.getMetadata
		end

		response = metadata.request :create do
			sbody = '<create xmlns="http://soap.sforce.com/2006/04/metadata">'+sFields+'</create>'

			#sbody = '<create xmlns="http://soap.sforce.com/2006/04/metadata"><metadata xsi:type="ns2:CustomObject" xmlns:ns2="http://soap.sforce.com/2006/04/metadata"><fullName>Demo_Report_Object__c</fullName><deploymentStatus>Deployed</deploymentStatus><description>created by the Metadata API</description><enableActivities>true</enableActivities><label>Report Object</label><nameField><displayFormat>AN-{0000}</displayFormat><label>sample__c Name</label><type>AutoNumber</type></nameField><pluralLabel>sample Objects</pluralLabel><sharingModel>ReadWrite</sharingModel></metadata></create>'
			soap.xml = setXML(sbody)
		end

		puts response
		return response

	end

	private

		def setXML(body)

			sid = @sessionId

			sNamespaces = '<?xml version="1.0" encoding="UTF-8"?><env:Envelope xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:env="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ns1="http://soap.sforce.com/2006/04/metadata">'
			sHeader = '<env:Header><ns1:SessionHeader env:mustUnderstand="0" ><ns1:sessionId>'+sid+'</ns1:sessionId></ns1:SessionHeader></env:Header>'
			sBody =	'<env:Body>'+body+'</env:Body></env:Envelope>'
			return sNamespaces+sHeader+sBody

		end


	    def metadataAPIClient

	    	#initialize partner api
			partner = ForcePartner.new(@username,@password,@token)
		  	@resp = partner.login
		  	
		  	#get required info for metadata api
	    	@sessionId =  @resp[:login_response][:result][:session_id]
			@metadataServerURL =  @resp[:login_response][:result][:metadataServerUrl]

			#initalize metadata api
		  	client = Savon::Client.new do
		  		wsdl.document = File.expand_path("../../../wsdls/metadata.wsdl", __FILE__)
		  		wsdl.endpoint = @metadataServerURL
			end

			#debug stuff
			#puts 'metadata Client actions : '
			#puts client.wsdl.soap_actions

			return client

	    end

end