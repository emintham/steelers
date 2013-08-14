require 'spec_helper'

describe "userfiles/new" do
  before(:each) do
    assign(:userfile, stub_model(Userfile,
      :user => nil,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new userfile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", userfiles_path, "post" do
      assert_select "input#userfile_user[name=?]", "userfile[user]"
      assert_select "input#userfile_name[name=?]", "userfile[name]"
    end
  end
end
