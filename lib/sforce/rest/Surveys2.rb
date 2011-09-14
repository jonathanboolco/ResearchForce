require 'sforce/rest/ForceUtils'

class Surveys2

  	def initialize(current_user)
    	@current_user = current_user
    	@serviceauth = @current_user.services.find(:first, :conditions => { :provider => 'forcedotcom' })
    	@client = Databasedotcom::Client.new
    	authenticate
	end

	def authenticate
		@client.authenticate :token => @serviceauth.token, :instance_url => @serviceauth.instance_url
	end

	def validate_session(e)

		begin

			if e.message == 'Session expired or invalid'
				puts 'Session has expired => Validating session...'
				ForceUtils.refreshToken(@current_user)
				authenticate
				return true
			else
				return false
			end

		rescue Exception => ex
			puts ex.inspect
			return false
		end

	end
 
	def get_user_surveys

		begin	
    		resp = @client.query("SELECT Id, Name, Status__c, Description__c,Published_Survey__c,Published_Survey__r.Name,Published_Survey__r.Num_of_Responses__c, Site_URL__c,Preview_URL__c, CreatedDate, CreatedBy.SmallPhotoUrl,CreatedById,CreatedBy.Name from Survey__c where OwnerId = '#{@serviceauth.uid}' and type__c = 'Draft' order by CreatedDate desc")
    		puts resp
    		return resp
    	rescue Exception => e

    		if(validate_session(e))
    			return get_user_surveys
    		else
    			return e.message
    		end
    	end

  	end

  def get_shared_surveys

	begin

		resp = @client.query("SELECT Id, Name, Status__c, Description__c,Published_Survey__c,Published_Survey__r.Name,Published_Survey__r.Num_of_Responses__c, Site_URL__c,Preview_URL__c, CreatedDate, CreatedBy.SmallPhotoUrl,CreatedById,CreatedBy.Name from Survey__c where OwnerId != '#{@serviceauth.uid}' and type__c = 'Draft' order by CreatedDate desc")
		return resp

	rescue Exception => e

		if(validate_session(e))
			return get_shared_surveys
		else
			return e.message
		end
	end

  end

  def get_user_published_surveys

	begin

		resp = @client.query("SELECT Id, Name, Status__c, Description__c,Response_Object__c,Response_Object_Prefix__c,Published_Survey__c,Published_Survey__r.Name,Published_Survey__r.Num_of_Responses__c, Site_URL__c,Preview_URL__c, CreatedDate, CreatedBy.SmallPhotoUrl,CreatedById,CreatedBy.Name from Survey__c where OwnerId = '#{@serviceauth.uid}' and type__c = 'Published' order by CreatedDate desc")
		return resp

	rescue Exception => e

		if(validate_session(e))
			return get_user_published_surveys
		else
			return e.message
		end
	end

  end

end