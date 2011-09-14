require 'sforce/metadata/ForceMetadata'
require 'sforce/metadata/ForceCustomObject'
require 'sforce/metadata/ForceCustomField'
require 'sforce/rest/Surveys'

class ReportsController < ApplicationController

	before_filter :authenticate, :only => [:builder,:publish,:status,:results]

	def builder

		@title = 'Publish Survey'
        surveyService = Surveys.new(current_user)

		if(params[:surveyid] != nil)
	        @survey = surveyService.get_survey(params[:surveyid])
	        @questionlines = surveyService.get_survey_questionlines(params[:surveyid])
	        puts @survey
		    puts @questionlines
    	end

	end

	def publish

		surveyid = params[:surveyid]
		finalResp = Hash.new
		finalResp[:id] = surveyid

		begin

			#initialize clients
			metadataservice = ForceMetadata.new('surveys_dev@jonathanrico.com','tcj4rixm','VshYOzh0zj6JAMG4fg6NsgS03')
			surveyService = Surveys.new(current_user)

			#get survey structure
			survey = surveyService.get_survey(surveyid)
			questions = surveyService.get_survey_questions(surveyid)
			answersequences = surveyService.get_survey_answer_sequences(surveyid)

			#create answer sequence map
			mapAnswerSequenceAndLabels = Hash.new
			answersequences["records"].each do |as|

				aAnswerLabels = Array.new
				as["LabelAnswers__r"]["records"].each do |al|
					aAnswerLabels << al["answerText__c"]
				end

				mapAnswerSequenceAndLabels[as["Id"]] = aAnswerLabels
					
			end

			ts = Time.now.utc.iso8601.gsub('-', '').gsub(':', '')

			customObjectFullName = 'CloudSurvey_Response_'+ts.to_s+'__c'
			customResponseNameSingular = 'CloudSurvey Response '+ts.to_s
			customResponseNamePlural = 'CloudSurvey Responses '+ts.to_s

			#create Custom Object programatically
			co = ForceCustomObject.new
			
			co.fullName = customObjectFullName
			co.deploymentStatus = 'Deployed'
			co.label = customResponseNameSingular
			co.pluralLabel = customResponseNamePlural
			co.description = 'Response Object created by Cloud Survey for Survey '+survey["records"][0]["Name"]+' ['+survey["records"][0]["Id"]+']'
			co.enableActivities = 'true' 
			co.enableReports = 'true'
			co.enableHistory = 'true'
			co.nameField = '<displayFormat>RN-{00000}</displayFormat><label>ID</label><type>AutoNumber</type>'
			co.sharingModel = 'ReadWrite'
			@resp = metadataservice.createCustomObject(co)

			#wait for some time while the custom object is being created
			puts 'timer on'
			sleep 20
			puts 'timer off'

			#create Common Fields
			aBasicFields = {'Survey__c' => 'Survey', 'Invitation__c'=>'Invitation', 'Contact' => 'Contact'}

			aCustomBasicFields = Array.new
			aBasicFields.each_pair do |k,v|
				sFullName = customObjectFullName+'.'+v.to_s+'__c'
				cf = ForceCustomField.new
				cf.fullName = sFullName
				cf.description = v.to_s
				cf.externalId = 'false'
				cf.label = v.to_s
				cf.referenceTo = k.to_s
				cf.relationshipName = customResponseNamePlural.gsub(' ','_')
				cf.relationshipLabel = customResponseNamePlural
				cf.required = 'false'
				cf.type = 'Lookup'
				aCustomBasicFields << cf
			end

			@resp = metadataservice.createCustomFields(aCustomBasicFields)
			aBasicFields.clear
			aCustomBasicFields.clear

			#create Custom Fields in batches of 10
			iBatchCount = 0;
			iTotalCount = 0;
			aQuestions = Array.new

			questions["records"].each do |q|
				
				iTotalCount=iTotalCount+1

				if(iBatchCount < 10)

					cf = ForceCustomField.new
					cf.fullName = customObjectFullName+'.'+q['Resource__c']+'__c'
					cf.description = q['description__c']
					cf.externalId = 'false'
					cf.label = q['Resource__c']
					cf.required = 'false'
					createCustomField = true

					case q['Type__c']

						when 'String'

							cf.type = 'TextArea'

						when 'Date'

							cf.type = 'Date'

						when 'Radio'

							cf.type = 'Picklist'
							aLabels = mapAnswerSequenceAndLabels[q["AnswerSequence__c"]]
							sPickListValues = ''
							aLabels.each do |al|
								sPickListValues+='<picklistValues><fullName>'+al.to_s+'</fullName><default>false</default></picklistValues>'
							end
							cf.picklist = sPickListValues
												
						when 'TextArea'

							cf.type = 'TextArea'

						when 'Integer'

							cf.type = 'Number'
							cf.scale  = '0'
							cf.precision = '2'

						when 'Boolean'

							cf.type = 'Checkbox'

						when 'SelectOneQuestion'

							cf.type = 'Picklist'
							aLabels = mapAnswerSequenceAndLabels[q["AnswerSequence__c"]]
							sPickListValues = ''
							aLabels.each do |al|
								sPickListValues+='<picklistValues><fullName>'+al.to_s+'</fullName><default>false</default></picklistValues>'
							end
							cf.picklist = sPickListValues

						when 'SelectMultipleQuestion'

							cf.type = 'MultiselectPicklist'
							aLabels = mapAnswerSequenceAndLabels[q["AnswerSequence__c"]]
							sPickListValues = ''
							aLabels.each do |al|
								sPickListValues+='<picklistValues><fullName>'+al.to_s+'</fullName><default>false</default></picklistValues>'
							end
							cf.picklist = sPickListValues
							cf.visibleLines = '4'

						else
							createCustomField = false

					end
					
					if(createCustomField)
						aQuestions << cf
						iBatchCount = iBatchCount + 1
					end

				end

				if(iBatchCount == 10 || iTotalCount == questions["records"].length)
					@resp = metadataservice.createCustomFields(aQuestions)
					aQuestions.clear
					iBatchCount = 0;
				end

			end

			respPublishedSurvey = surveyService.publish_survey(surveyid,customObjectFullName)

			finalResp[:status] = 'done'
			finalResp[:publishedId] = respPublishedSurvey["records"][0]["Published_Survey__c"]

		rescue

			finalResp[:status] = 'error'

		end

	    respond_to do |format|
	      format.json {render :json => finalResp}
	    end

	end


	def status
		@title = 'Publish Status'
	end

	def results
		@title = 'Publish Results'
		@serviceauth = current_user.services.find(:first, :conditions => { :provider => 'forcedotcom' })
	end


end
