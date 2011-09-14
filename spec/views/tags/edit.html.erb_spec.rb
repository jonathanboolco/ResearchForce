require 'spec_helper'

describe "tags/edit.html.erb" do
  before(:each) do
    @tag = assign(:tag, stub_model(Tag,
      :name => "MyString",
      :id => 1
    ))
  end

  it "renders the edit tag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tags_path(@tag), :method => "post" do
      assert_select "input#tag_name", :name => "tag[name]"
      assert_select "input#tag_id", :name => "tag[id]"
    end
  end
end
