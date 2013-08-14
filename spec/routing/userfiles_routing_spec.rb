require "spec_helper"

describe UserfilesController do
  describe "routing" do

    it "routes to #index" do
      get("/userfiles").should route_to("userfiles#index")
    end

    it "routes to #new" do
      get("/userfiles/new").should route_to("userfiles#new")
    end

    it "routes to #show" do
      get("/userfiles/1").should route_to("userfiles#show", :id => "1")
    end

    it "routes to #edit" do
      get("/userfiles/1/edit").should route_to("userfiles#edit", :id => "1")
    end

    it "routes to #create" do
      post("/userfiles").should route_to("userfiles#create")
    end

    it "routes to #update" do
      put("/userfiles/1").should route_to("userfiles#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/userfiles/1").should route_to("userfiles#destroy", :id => "1")
    end

  end
end
