require 'spec_helper'

describe "config_templates/edit" do
  before(:each) do
    @config_template = assign(:config_template, stub_model(ConfigTemplate,
      :name => "MyString"
    ))
  end

  it "renders the edit config_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", config_template_path(@config_template), "post" do
      assert_select "input#config_template_name[name=?]", "config_template[name]"
    end
  end
end
