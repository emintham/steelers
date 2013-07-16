require 'spec_helper'

describe "confs/edit" do
  before(:each) do
    @conf = assign(:conf, stub_model(Conf,
      :name => "MyString",
      :program => nil
    ))
  end

  it "renders the edit conf form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", conf_path(@conf), "post" do
      assert_select "input#conf_name[name=?]", "conf[name]"
      assert_select "input#conf_program[name=?]", "conf[program]"
    end
  end
end
