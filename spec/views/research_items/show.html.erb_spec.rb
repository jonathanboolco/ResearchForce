require 'spec_helper'

describe "research_items/show.html.erb" do
  before(:each) do
    @research_item = assign(:research_item, stub_model(ResearchItem,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
