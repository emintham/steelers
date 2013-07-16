require 'spec_helper'

describe "config_templates/new" do
  before(:each) do
    assign(:config_template, stub_model(ConfigTemplate,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new config_template form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", config_templates_path, "post" do
      assert_select "input#config_template_name[name=?]", "config_template[name]"
    end
  end
end
