require "rails_helper"

RSpec.describe "venues/show.html.erb", type: :view do
  context "expected elements when show" do
    let(:venue) {FactoryGirl.create :venue}

    before do
      assign :venue, venue
    end

    it "should index venue" do
      render
      expect(rendered).to include venue.name
    end
  end
end
