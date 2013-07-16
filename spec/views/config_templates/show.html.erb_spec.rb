require 'spec_helper'

describe "config_templates/show" do
  before(:each) do
    @config_template = assign(:config_template, stub_model(ConfigTemplate,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
