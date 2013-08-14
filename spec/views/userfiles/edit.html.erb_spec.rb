require 'spec_helper'

describe "userfiles/edit" do
  before(:each) do
    @userfile = assign(:userfile, stub_model(Userfile,
      :user => nil,
      :name => "MyString"
    ))
  end

  it "renders the edit userfile form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", userfile_path(@userfile), "post" do
      assert_select "input#userfile_user[name=?]", "userfile[user]"
      assert_select "input#userfile_name[name=?]", "userfile[name]"
    end
  end
end
