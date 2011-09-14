require 'spec_helper'

describe "tags/show.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Tag,
      :name => "Name",
      :id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
  end
end
