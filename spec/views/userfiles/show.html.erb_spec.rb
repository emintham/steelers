require 'spec_helper'

describe "userfiles/show" do
  before(:each) do
    @userfile = assign(:userfile, stub_model(Userfile,
      :user => nil,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/Name/)
  end
end
