require 'spec_helper'

describe "config_templates/index" do
  before(:each) do
    assign(:config_templates, [
      stub_model(ConfigTemplate,
        :name => "Name"
      ),
      stub_model(ConfigTemplate,
        :name => "Name"
      )
    ])
  end

  it "renders a list of config_templates" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
