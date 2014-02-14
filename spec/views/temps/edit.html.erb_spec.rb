require 'spec_helper'

describe "temps/edit" do
  before(:each) do
    @temp = assign(:temp, stub_model(Temp))
  end

  it "renders the edit temp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", temp_path(@temp), "post" do
    end
  end
end
