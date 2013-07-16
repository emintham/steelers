require 'spec_helper'

describe "confs/show" do
  before(:each) do
    @conf = assign(:conf, stub_model(Conf,
      :name => "Name",
      :program => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(//)
  end
end
