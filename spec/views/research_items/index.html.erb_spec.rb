require 'spec_helper'

describe "research_items/index.html.erb" do
  before(:each) do
    assign(:research_items, [
      stub_model(ResearchItem,
        :name => "Name"
      ),
      stub_model(ResearchItem,
        :name => "Name"
      )
    ])
  end

  it "renders a list of research_items" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
