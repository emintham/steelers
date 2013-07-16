require "spec_helper"

describe ConfigTemplatesController do
  describe "routing" do

    it "routes to #index" do
      get("/config_templates").should route_to("config_templates#index")
    end

    it "routes to #new" do
      get("/config_templates/new").should route_to("config_templates#new")
    end

    it "routes to #show" do
      get("/config_templates/1").should route_to("config_templates#show", :id => "1")
    end

    it "routes to #edit" do
      get("/config_templates/1/edit").should route_to("config_templates#edit", :id => "1")
    end

    it "routes to #create" do
      post("/config_templates").should route_to("config_templates#create")
    end

    it "routes to #update" do
      put("/config_templates/1").should route_to("config_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/config_templates/1").should route_to("config_templates#destroy", :id => "1")
    end

  end
end
