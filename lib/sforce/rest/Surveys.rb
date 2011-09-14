require 'httparty'
require 'base64'
require 'rexml/document'
require 'sforce/rest/ForceUtils'

class Surveys

  include HTTParty

  def initialize(current_user)
    @current_user = current_user
    @serviceauth = @current_user.services.find(:first, :conditions => { :provider => 'forcedotcom' })
    @accesstoken = nil
  end

  def print_response(name, response)
    puts '>>>> action : '+name
    puts '>>>> response : '+response.inspect
    puts '>>>> response Code : '+response.code.to_s
  end

  def set_headers
    Surveys.headers 'Authorization' => "OAuth #{@serviceauth.token}"
    Surveys.headers 'Content-Type' => "application/json"
  end

  def root_url
    @root_url = @serviceauth.instance_url+"/services/data/v"+ENV['sfdc_api_version']
  end

  def get_user_surveys

    puts '>>> SURVEY LIST >>> '
    set_headers

    #create survey
    soql = "SELECT Id, Name, Status__c, Description__c,Published_Survey__c,Published_Survey__r.Name,Published_Survey__r.Num_of_Responses__c, Site_URL__c,Preview_URL__c, CreatedDate, CreatedBy.SmallPhotoUrl,CreatedById,CreatedBy.Name from Survey__c where OwnerId = '#{@serviceauth.uid}' and type__c = 'Draft' order by CreatedDate desc"
    resp = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")
    print_response('get_user_surveys',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp = get_user_surveys
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end

  def get_shared_surveys

    puts '>>> SHARED SURVEY LIST >>> '

    set_headers
    #create survey
    soql = "SELECT Id, Name, Status__c, Description__c,Published_Survey__c,Published_Survey__r.Name,Published_Survey__r.Num_of_Responses__c, Site_URL__c,Preview_URL__c, CreatedDate, CreatedBy.SmallPhotoUrl,CreatedById,CreatedBy.Name from Survey__c where OwnerId != '#{@serviceauth.uid}' and type__c = 'Draft' order by CreatedDate desc"
    resp = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")

    print_response('get_shared_surveys',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp =  get_shared_surveys
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end

  def get_user_published_surveys

    puts '>>> PUBLISHED SURVEY LIST >>> '

    set_headers
    #create survey
    soql = "SELECT Id, Name, Status__c, Description__c,Response_Object__c,Response_Object_Prefix__c,Published_Survey__c,Published_Survey__r.Name,Published_Survey__r.Num_of_Responses__c, Site_URL__c,Preview_URL__c, CreatedDate, CreatedBy.SmallPhotoUrl,CreatedById,CreatedBy.Name from Survey__c where OwnerId = '#{@serviceauth.uid}' and type__c = 'Published' order by CreatedDate desc"
    resp = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")

    print_response('get_user_published_surveys',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp = get_user_published_surveys
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end

  def get_survey_xml(sid)

    puts '>>> SURVEY LOAD >>> '+sid

    Surveys.headers 'Authorization' => "OAuth #{@serviceauth.token}"
    Surveys.headers 'Content-Type' => "text/xml"

    #create survey
    soql = "SELECT Id,Name,(select id from Attachments) from Survey_RDF__c where Survey__c = \'#{sid}\' and Is_Active__c = true order by CreatedDate desc limit 1"
    surveyRDF = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")

    print_response('get_survey_xml (Get Survey RDF)',surveyRDF)

    attachment = surveyRDF["records"][0]["Attachments"]["records"][0]

    attachmentid = attachment["Id"]
    resp = Surveys.get(root_url+"/sobjects/Attachment/#{attachmentid}/Body")

    print_response('get_survey_xml (Get Body)',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp = get_survey_xml(sid)
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end

  def get_survey(sid)

    puts '>>> GET SURVEY >>> '+sid

    set_headers

    #create survey
    soql = "SELECT Id,Name,Active_Version__c, Description__c,Status__c,Type__c,(select id,name,sort_order__c,description__c from Question_Line__r order by  sort_order__c asc) from Survey__c where id = \'#{sid}\' limit 1"
    resp = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")

    print_response('get_survey (Get Survey)',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp = get_survey(sid)
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end


  def get_survey_questionlines(sid)

    puts '>>> GET SURVEY QUESTION Lines >>> '+sid

    set_headers

    #create survey
    soql = "SELECT id,name,sort_order__c,description__c,Survey__c,(select id,name,Required__c,Resource__c,AnswerSequence__c,Display_Format__c,Question_Description__c,Team__c,Type__c,Sort_Order__c,SurveyAnswerNumber__c from Questions__r order by Sort_Order__c asc) from Question_Line__c where Survey__c = \'#{sid}\'"
    resp = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")

    print_response('get_survey_questionlines (Get Survey Question Lines)',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp = get_survey_questionlines(sid)
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end


  def get_survey_questions(sid)

    puts '>>> GET SURVEY Question Lines >>> '+sid

    set_headers

    #create survey
    soql = "SELECT id,name,Required__c,Resource__c,AnswerSequence__c,Display_Format__c,Question_Description__c,Team__c,Type__c,Sort_Order__c,SurveyAnswerNumber__c from Question__c where Question_Line__r.Survey__c = \'#{sid}\'"
    resp = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")

    print_response('get_survey_questions (Get Survey Questions)',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp = get_survey_questions(sid)
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end

  def get_survey_answer_sequences(sid)

    puts '>>> GET SURVEY Answer Sequences >>> '+sid

    set_headers

    #create survey
    soql = "SELECT id,name,Survey__c,(select id,name,answerText__c,resource__c,Sort_Order__c from LabelAnswers__r order by Sort_Order__c asc) from AnswerSequence__c where Survey__c = \'#{sid}\'"
    resp = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")

    print_response('get_survey_answer_sequences (Get Answer Sequences)',resp)

    if(resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      resp = get_survey_answer_sequences(sid)
    elsif (resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{resp.inspect}"
    end

    return resp

  end

  def publish_survey(sid,customObjectName)

    puts '>>> PUBLISH SURVEY >>> '+sid

    set_headers

    #update specified survey if we have the survey id in the parameters
    options = {
      :body => {
        :type__c => 'Published'
      }.to_json
    }

    #update survey
    result = Surveys.post(root_url+"/sobjects/survey__c/"+sid+"/?_HttpMethod=PATCH", options)
    print_response('publish_survey (Publish Survey)',result)

    if(result.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      return publish_survey(sid,customObjectName)
    elsif (result.code != 200 && result.code != 204)
      raise StandardError, "unknown failure getting uri with #{result.inspect}"
    end

    soql = "SELECT Id,Name,Active_Version__c,Published_Survey__c,Published_Survey_RDF__c from Survey__c where id = \'#{sid}\' limit 1"
    result = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")
    print_response('get_published_survey (Get Published Survey)',result)

    #update Publushed survey
    options = {
      :body => {
        :Response_Object__c => customObjectName
      }.to_json
    }
    updateResult = Surveys.post(root_url+"/sobjects/survey__c/"+result["records"][0]["Published_Survey__c"]+"/?_HttpMethod=PATCH", options)
    print_response('update_published_survey (Update Published Survey)',updateResult)

    return result

  end

  def create(params)

    #set default values for survey
    surveyid = ''
    surveyName  =  'Untitled'
    description = ''
    surveyMode = ''
  
    #get some of the data from the xml
    doc = REXML::Document.new(params[:srdf])

    #get title
    doc.elements.each('Survey/rdf:RDF/Survey/dc:title') do |ele|
       surveyName = ele.text
    end 
    #get description
    doc.elements.each('Survey/rdf:RDF/Survey/dc:description') do |ele|
       description = ele.text
    end 
    #get mode
    doc.elements.each('Survey/rdf:RDF/Survey/mode') do |ele|
       surveyMode = ele.text
    end 

    #get survey id
    surveyid  = params[:surveyid]

    #set request headers
    set_headers

    #initialize response as nil
    @resp = nil
    bSurveySaved = false

    if(surveyid != nil && surveyid.length > 0)
      
      surveyid = surveyid.sub('#','')

      puts '>>> SURVEY UPDATE >>> '+surveyid
      
       #update specified survey if we have the survey id in the parameters
      options = {
        :body => {
          :name => surveyName,
          :description__c => description,
          :status__c => surveyMode,
        }.to_json
      }

      #update survey
      result = Surveys.post(root_url+"/sobjects/survey__c/"+surveyid+"/?_HttpMethod=PATCH", options)
        
      print_response('Update survey result : ',result)

      if(result.code == 401)
        ForceUtils.refreshToken(@current_user)
        initialize(@current_user)
        return create(params)
      elsif(result.code == 204)
          bSurveySaved = true
          @resp = {:id => surveyid, :code => result.code, :operation => 'update'}
      else
          @resp = {:id => '', :code => result.code, :operation => 'update'}
      end

    else

      puts '>>> NEW SURVEY INSERT >>>'

      #create a new survey if we dont have a survey id in the url
      options = {
        :body => {
          :name => surveyName,
          :description__c => description,
          :status__c => surveyMode,
          :type__c => 'Draft'
        }.to_json
      }

      #create survey
      result = Surveys.post(root_url+"/sobjects/survey__c/", options)

      print_response('Insert survey result : ',result)

      if(result.code == 201)
        bSurveySaved = true
        surveyid = result["id"]
        @resp = {:id => surveyid, :code => result.code, :operation => 'insert'}
      else
        @resp = {:id => '', :code => result.code, :operation => 'insert'}
      end

    end

    #create attachment
    if(bSurveySaved)

      #get survey version
      soql = "SELECT Id,Latest_Version__c,Active_Version__c from Survey__c where id = \'#{surveyid}\'"
      sfSurvey = Surveys.get(root_url+"/query/?q=#{CGI::escape(soql)}")
      
      print_response('Survey Query result : ',sfSurvey)

      surveyVersion = 1.0
      if(sfSurvey["records"][0]["Latest_Version__c"] != nil)
        surveyVersion += sfSurvey["records"][0]["Latest_Version__c"]
      end

      options = {
        :body => {
          :Survey__c => surveyid,
          :name => 'Survey RDF V'+surveyVersion.to_s,
          :version__c =>  surveyVersion,
          :is_active__c => false
        }.to_json
      }

      #create survey RDF
      result = Surveys.post(root_url+"/sobjects/Survey_RDF__c/", options)

      print_response('Create Survey RDF Response : ',result )
      
      if(result.code == 201)

        surveyRDFid = result["id"]
 
        options = {
          :body => {
            :name => 'surveyrdf.xml',
            :parentId => surveyRDFid,
            :body => Base64.encode64(params[:srdf])
          }.to_json
        }
             
        #create survey attachment
        respatt = Surveys.post(root_url+"/sobjects/Attachment/", options)
        print_response('Insert attachment result : ', respatt)

        #Activate Survey RDF
        options = {
          :body => {
            :is_active__c => true
          }.to_json
        }

        #update survey
        result = Surveys.post(root_url+"/sobjects/survey_rdf__c/"+surveyRDFid+"/?_HttpMethod=PATCH", options)

        print_response('Update attachment result : ', result)
        
      end

    end

    return @resp
    
  end

  
end