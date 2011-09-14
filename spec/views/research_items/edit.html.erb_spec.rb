require 'spec_helper'

describe "research_items/edit.html.erb" do
  before(:each) do
    @research_item = assign(:research_item, stub_model(ResearchItem,
      :name => "MyString"
    ))
  end

  it "renders the edit research_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => research_items_path(@research_item), :method => "post" do
      assert_select "input#research_item_name", :name => "research_item[name]"
    end
  end
end
