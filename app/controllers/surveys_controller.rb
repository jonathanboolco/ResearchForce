require 'sforce/rest/Surveys'

class SurveysController < ApplicationController

  before_filter :authenticate, :only => [:builder,:preview,:export,:createsurvey,:my_surveys,:upsert]

  def builder
    @title = 'Survey Builder'

   #defaultSurveyDef = '<Survey><id> </id><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"><Survey rdf:about="1"><surveyLine rdf:resource="#mainline"></surveyLine></Survey><Line rdf:about="#mainline"><internalName>Main Section</internalName></Line></rdf:RDF></Survey>'

    defaultSurveyDef = '<Survey><rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:dc="http://purl.org/dc/elements/1.1/"><Survey><surveyLine rdf:resource="#mainline"></surveyLine></Survey><Line rdf:about="#mainline"><internalName>Main Section</internalName></Line></rdf:RDF></Survey>'
    begin

      if(params[:surveyid] != nil)

        #initialize survey service
        surveyService = Surveys.new(current_user)
        @resp = surveyService.get_survey_xml(params[:surveyid])
        @resp = @resp.gsub(/\n|\r|\t/, '')
        @resp = @resp.gsub(/'/, '\\\\\'')

        @serviceauth = current_user.services.find(:first, :conditions => { :provider => 'forcedotcom' })
        flash.now[:success] = "Survey defintion has been succesfully loaded."

        instance_url = @serviceauth.instance_url
        @preview_url = instance_url+'/apex/QuestionLine?pid='+params[:surveyid]
        @publish_url = reports_builder_path+'?surveyid='+params[:surveyid]
        @salesforce_url = instance_url+'/'+params[:surveyid]

        puts @resp
        
      else
        #@resp = nil
        @resp = defaultSurveyDef

      end

    rescue

      flash.now[:error] = 'Oops there was an error loading the survey definition'
      @resp = defaultSurveyDef

    end

  end

  def my_surveys
    @title = 'My Surveys'

    #initialize survey service
    surveyService = Surveys.new(current_user)

    #create the survey
    @resp = surveyService.get_user_surveys;
    @respShared = surveyService.get_shared_surveys;
    @respPublished = surveyService.get_user_published_surveys;

    #display results
    @serviceauth = current_user.services.find(:first, :conditions => { :provider => 'forcedotcom' })

  end

  def preview
    render :layout => 'surveypreview'  
    @title = 'Survey Preview'
  end

  def export
  	@title = 'Survey Export'
  end

  def upsert

    #initialize survey service
    surveyService = Surveys.new(current_user)

    #create the survey
    resp = surveyService.create(params)
    respond_to do |format|
      format.json {render :json => resp}
    end

  end

end
