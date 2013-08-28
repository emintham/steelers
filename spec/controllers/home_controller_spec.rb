require 'spec_helper'

describe HomeController do

  describe "GET 'job_landing'" do
    it "returns http success" do
      get 'job_landing'
      response.should be_success
    end
  end

end
