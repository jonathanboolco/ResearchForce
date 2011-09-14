require 'spec_helper'

describe "research_items/new.html.erb" do
  before(:each) do
    assign(:research_item, stub_model(ResearchItem,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new research_item form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => research_items_path, :method => "post" do
      assert_select "input#research_item_name", :name => "research_item[name]"
    end
  end
end
