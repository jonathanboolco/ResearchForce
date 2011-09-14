class ResearchItemController < ApplicationController

 def index
    
    @title = "All users"
    
    @research_items = User.paginate(:page => params[:page])

    
  end

end
