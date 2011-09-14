require "spec_helper"

describe ResearchItemsController do
  describe "routing" do

    it "routes to #index" do
      get("/research_items").should route_to("research_items#index")
    end

    it "routes to #new" do
      get("/research_items/new").should route_to("research_items#new")
    end

    it "routes to #show" do
      get("/research_items/1").should route_to("research_items#show", :id => "1")
    end

    it "routes to #edit" do
      get("/research_items/1/edit").should route_to("research_items#edit", :id => "1")
    end

    it "routes to #create" do
      post("/research_items").should route_to("research_items#create")
    end

    it "routes to #update" do
      put("/research_items/1").should route_to("research_items#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/research_items/1").should route_to("research_items#destroy", :id => "1")
    end

  end
end
