require 'spec_helper'

describe "temps/new" do
  before(:each) do
    assign(:temp, stub_model(Temp).as_new_record)
  end

  it "renders new temp form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", temps_path, "post" do
    end
  end
end
