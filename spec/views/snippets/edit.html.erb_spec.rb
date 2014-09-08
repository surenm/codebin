require 'rails_helper'

RSpec.describe "snippets/edit", :type => :view do
  before(:each) do
    @snippet = assign(:snippet, Snippet.create!())
  end

  it "renders the edit snippet form" do
    render

    assert_select "form[action=?][method=?]", snippet_path(@snippet), "post" do
    end
  end
end
