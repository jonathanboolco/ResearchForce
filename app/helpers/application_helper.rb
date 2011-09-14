module ApplicationHelper
  
   #Return the logo reference
   def logo
    image_tag("logo.png", :alt => "Research Force ", :class => "round")
   end

   # Return a title on a per-page basis.
   def title
    base_title = "Research Force"

    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
    
   end
   
   def self.salesforce_client(refresh_token, sf_consumer_key, sf_consumer_secret)
    payload = 'grant_type=refresh_token' + '&client_id=' + sf_consumer_key + '&client_secret=' + sf_consumer_secret + '&refresh_token=' + refresh_token
    result = HTTParty.post('https://login.salesforce.com/services/oauth2/token',:body => payload)
    return result
   end   
 
end
