require 'spec_helper'

describe "temps/index" do
  before(:each) do
    assign(:temps, [
      stub_model(Temp),
      stub_model(Temp)
    ])
  end

  it "renders a list of temps" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
