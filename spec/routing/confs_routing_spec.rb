require "spec_helper"

describe ConfsController do
  describe "routing" do

    it "routes to #index" do
      get("/confs").should route_to("confs#index")
    end

    it "routes to #new" do
      get("/confs/new").should route_to("confs#new")
    end

    it "routes to #show" do
      get("/confs/1").should route_to("confs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/confs/1/edit").should route_to("confs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/confs").should route_to("confs#create")
    end

    it "routes to #update" do
      put("/confs/1").should route_to("confs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/confs/1").should route_to("confs#destroy", :id => "1")
    end

  end
end
