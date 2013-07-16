require 'spec_helper'

describe "confs/new" do
  before(:each) do
    assign(:conf, stub_model(Conf,
      :name => "MyString",
      :program => nil
    ).as_new_record)
  end

  it "renders new conf form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", confs_path, "post" do
      assert_select "input#conf_name[name=?]", "conf[name]"
      assert_select "input#conf_program[name=?]", "conf[program]"
    end
  end
end
