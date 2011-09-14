require 'spec_helper'

describe "tags/new.html.erb" do
  before(:each) do
    assign(:tag, stub_model(Tag,
      :name => "MyString",
      :id => 1
    ).as_new_record)
  end

  it "renders new tag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => tags_path, :method => "post" do
      assert_select "input#tag_name", :name => "tag[name]"
      assert_select "input#tag_id", :name => "tag[id]"
    end
  end
end
