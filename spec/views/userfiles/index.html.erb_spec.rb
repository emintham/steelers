require 'spec_helper'

describe "userfiles/index" do
  before(:each) do
    assign(:userfiles, [
      stub_model(Userfile,
        :user => nil,
        :name => "Name"
      ),
      stub_model(Userfile,
        :user => nil,
        :name => "Name"
      )
    ])
  end

  it "renders a list of userfiles" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
