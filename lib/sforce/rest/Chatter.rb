require 'httparty'

class Chatter

  include HTTParty

  format :json
  #debug_output $stderr

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
    Chatter.headers 'Authorization' => "OAuth #{@serviceauth.token}"
  end

  def root_url
    @root_url = @serviceauth.instance_url+"/services/data/v"+ENV['sfdc_api_version']+"/chatter"
  end

  def get_users_info(id)
    set_headers
    @resp = Chatter.get(root_url+"/users/"+id)

    print_response('get_users_info',@resp)

    if(@resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      @resp = get_users_info(id)
    elsif (@resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{@resp.inspect}"
    end

    return @resp
  end

  def get_my_info
    get_users_info("me")
  end
  
  def get_newsfeed(id)
    set_headers
    @resp = Chatter.get(root_url+"/feeds/news/"+id)

    print_response('get_newsfeed',@resp)

    if(@resp.code == 401)
      ForceUtils.refreshToken(@current_user)
      initialize(@current_user)
      @resp = get_newsfeed(id)
    elsif (@resp.code != 200)
      raise StandardError, "unknown failure getting uri with #{@resp.inspect}"
    end

    log_response(@resp, "get_newsfeed")
    return @resp

  end
    
  def get_my_newsfeed
    get_newsfeed("me")
  end
  
  def set_my_user_status(post)
    Chatter.post(root_url+"/feeds/news/me/feed-items?text="+CGI::escape(Chatter.post.body))
  end
  
  def like_feeditem(id)
    Chatter.post(root_url+"/feed-items/"+id+"/likes")
  end
  
  def unlike_feeditem(id)
    delete(root_url+"/feed-items/"+id+"/likes")
  end
  
  def add_comment(comment)
    Chatter.post(root_url+"/feed-items/"+comment.feeditemid+"/comments?text="+CGI::escape(comment.body))
  end
  
  #pre rel chatter page results returns the incorrect json response. it should be [feeditems][items]
  #like everything else, but it is just [items] so lets wrap it to make it consistent
  def get_page_of_feed(refpath)
    set_headers
    
     @feed = Hash.new{}
      @feed["feedItems"] = Hash.new{} 
      
       @feed["feedItems"] = Chatter.get(@serviceauth.instance_url+refpath)
       return @feed
  end
  
  def log_response(resp, method_name)
    CHATTER_LOGGER.debug("\n------START "+method_name+"---------\n")
    CHATTER_LOGGER.debug(resp)
    CHATTER_LOGGER.debug("\n------END "+method_name+"---------\n")
  end

end