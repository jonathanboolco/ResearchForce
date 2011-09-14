class SessionsController < ApplicationController

  def new
    @title = "Sign in"
  end

  def login
    redirect_to root_path
  end

  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
      
  def create

    #obtain name of the service
    params[:provider] ? service_route = params[:provider] : service_route = 'No service recognized (invalid callback)'

    # get the full hash from omniauth
    omniauth = request.env['omniauth.auth']

    # continue only if hash and parameter exist
    if omniauth and params[:provider]

      # map the returned hashes to our variables first - the hashes will differ for every service

      # create a new hash
      @authhash = Hash.new

      if service_route == 'forcedotcom'

        #render :text => omniauth.inspect
        omniauth['provider'] ? @authhash[:provider] =  omniauth['provider'] : @authhash[:provider] = ''
        omniauth['extra']['user_hash']['user_id'] ? @authhash[:uid] =  omniauth['extra']['user_hash']['user_id'] : @authhash[:uid] = ''
        omniauth['extra']['user_hash']['username'] ? @authhash[:username] =  omniauth['extra']['user_hash']['username'] : @authhash[:username] = ''
        omniauth['extra']['user_hash']['nickname'] ? @authhash[:nickname] =  omniauth['extra']['user_hash']['nickname'] : @authhash[:nickname] = ''
        omniauth['extra']['user_hash']['status']['body'] ? @authhash[:last_status_body] =  omniauth['extra']['user_hash']['status']['body'] : @authhash[:last_status_body] = ''
        omniauth['extra']['user_hash']['status']['created_date'] ? @authhash[:last_status_created_date] =  omniauth['extra']['user_hash']['status']['created_date'] : @authhash[:last_status_created_date] = ''
        omniauth['extra']['user_hash']['email'] ? @authhash[:email] =  omniauth['extra']['user_hash']['email'] : @authhash[:email] = ''
        omniauth['extra']['user_hash']['display_name'] ? @authhash[:name] =  omniauth['extra']['user_hash']['display_name'] : @authhash[:name] = ''
        omniauth['extra']['user_hash']['urls']['recent'] ? @authhash[:profile] =  omniauth['extra']['user_hash']['urls']['recent'] : @authhash[:profile] = ''
        omniauth['extra']['user_hash']['photos']['thumbnail'] ? @authhash[:thumbnail] =  omniauth['extra']['user_hash']['photos']['thumbnail'] : @authhash[:thumbnail] = ''
        omniauth['extra']['user_hash']['organization_id'] ? @authhash[:org_id] =  omniauth['extra']['user_hash']['organization_id'] : @authhash[:org_id] = ''
        omniauth['extra']['user_hash']['photos']['picture'] ? @authhash[:picture] =  omniauth['extra']['user_hash']['photos']['picture'] : @authhash[:picture] = ''
        omniauth['extra']['user_hash']['active'] ? @authhash[:active] =  omniauth['extra']['user_hash']['active'] : @authhash[:active] = ''
        omniauth['extra']['user_hash']['user_type'] ? @authhash[:user_type] =  omniauth['extra']['user_hash']['user_type'] : @authhash[:user_type] = ''    
        omniauth['extra']['user_hash']['language'] ? @authhash[:language] =  omniauth['extra']['user_hash']['language'] : @authhash[:language] = ''
        omniauth['extra']['user_hash']['utcOffset'] ? @authhash[:utcOffset] =  omniauth['extra']['user_hash']['utcOffset'] : @authhash[:utcOffset] = ''
        omniauth['extra']['user_hash']['last_modified_date'] ? @authhash[:last_modified_date] =  omniauth['extra']['user_hash']['last_modified_date'] : @authhash[:last_modified_date] = ''
        omniauth['credentials']['instance_url'] ? @authhash[:sfdc_instance_url] =  omniauth['credentials']['instance_url'] : @authhash[:sfdc_instance_url] = ''
        
        #Set Tokens         
        @authhash[:token] = omniauth['credentials']['token']
        @authhash[:token_secret] = '' #Not used only for LinkedIn / Twitter
        @authhash[:token_refresh] = omniauth['credentials']['refresh_token']
        #@authhash[:sf_consumer_key] = omniauth['credentials']['consumer_key']
        #@authhash[:sf_consumer_secret] = omniauth['credentials']['consumer_secret']

        #Set Env vars
        user = User.find_by_user_id(@authhash[:uid])

        if user.nil?

          user = User.new(:user_id => @authhash[:uid],
                           :email => @authhash[:email], 
                           :name => @authhash[:name],
                           :nickname => @authhash[:nickname],
                           :thumbnail => @authhash[:thumbnail],
                           :picture => @authhash[:picture],
                           :active => @authhash[:active],
                           :language => @authhash[:language],
                           :utcOffset => @authhash[:utcOffset],
                           :last_modified_date => @authhash[:last_modified_date]
                        )
                        
          user.services.build(
            :provider => @authhash[:provider],
            :uid => @authhash[:uid],
            :uname => @authhash[:username],
            :uemail => @authhash[:email],
            :token => @authhash[:token],
            :token_secret => @authhash[:token_secret],
            :token_refresh => @authhash[:token_refresh],
            :instance_url => @authhash[:sfdc_instance_url],
            :org_id => @authhash[:org_id],
            :user_type => @authhash[:user_type],
            :active => @authhash[:active],
            :last_status_update => @authhash[:last_status_body],
            :last_status_created_date => @authhash[:last_status_created_date],
            :profile => @authhash[:profile]
          )

          if user.save!
            # signin existing user
            # in the session his user id and the service id used for signing in is stored
            session[:user_id] = user.id
            session[:service_id] = user.services.first.id
            
          else
            flash[:error] = 'This is embarrassing! There was an error while creating your account from which we were not able to recover.'
            redirect_to root_path
          end  

        else

          #update some basic in the user
          user.picture = @authhash[:picture]
          user.thumbnail = @authhash[:thumbnail]
          user.last_modified_date = @authhash[:last_modified_date]
          user.save
          
          #get forcedotcom service and update informaiton
          serviceauth = user.services.find(:first, :conditions => { :provider => service_route })
          serviceauth.token = @authhash[:token]
          serviceauth.token_refresh = @authhash[:token_refresh]
          serviceauth.user_type = @authhash[:user_type]
          serviceauth.active = @authhash[:active]
          serviceauth.last_status_update = @authhash[:last_status_body]
          serviceauth.last_status_created_date = @authhash[:last_status_created_date]
          serviceauth.profile = @authhash[:profile]
          serviceauth.save

        end
      
      else
        # debug to output the hash that has been returned when adding new services
        render :text => omniauth.to_yaml
        return
      end

      if @authhash[:uid] != '' and @authhash[:provider] != ''

        auth = Service.find_by_provider_and_uid(@authhash[:provider], @authhash[:uid])

        sign_in user
        flash[:success] = "Hi "+user.name+" ,  Welcome to our Survey Service!"
        redirect_back_or user
        #redirect_to root_path
      else

        flash[:error] =  'Error while authenticating via ' + service_route + '/' + @authhash[:provider].capitalize + '. The service returned invalid data for the user id.'
        redirect_to signup_path
      end
    
    else
      flash[:error] = 'Error while authenticating via ' + service_route.capitalize + '. The service did not return valid data.'
      redirect_to signup_path
    end

    return

  end

  def fail
    flash[:error] = "Oops, there was an error in the authentaction process."
    redirect_to root_path
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end