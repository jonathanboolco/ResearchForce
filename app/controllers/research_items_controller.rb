class ResearchItemsController < ApplicationController
  # GET /research_items
  # GET /research_items.json
  def index
    @research_items = ResearchItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @research_items }
    end
  end

  # GET /research_items/1
  # GET /research_items/1.json
  def show
    @research_item = ResearchItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @research_item }
    end
  end

  # GET /research_items/new
  # GET /research_items/new.json
  def new
    @research_item = ResearchItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @research_item }
    end
  end

  # GET /research_items/1/edit
  def edit
    @research_item = ResearchItem.find(params[:id])
  end

  # POST /research_items
  # POST /research_items.json
  def create
    @research_item = ResearchItem.new(params[:research_item])

    respond_to do |format|
      if @research_item.save
        format.html { redirect_to @research_item, :notice => 'Research item was successfully created.' }
        format.json { render :json => @research_item, :status => :created, :location => @research_item }
      else
        format.html { render :action => "new" }
        format.json { render :json => @research_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /research_items/1
  # PUT /research_items/1.json
  def update
    @research_item = ResearchItem.find(params[:id])

    respond_to do |format|
      if @research_item.update_attributes(params[:research_item])
        format.html { redirect_to @research_item, :notice => 'Research item was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @research_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /research_items/1
  # DELETE /research_items/1.json
  def destroy
    @research_item = ResearchItem.find(params[:id])
    @research_item.destroy

    respond_to do |format|
      format.html { redirect_to research_items_url }
      format.json { head :ok }
    end
  end
end
