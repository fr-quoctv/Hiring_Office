require "rails_helper"

RSpec.describe "admin/venues/show.html.erb", type: :view do
  Venue.public_activity_off
  context "expected elements when show" do
    let(:venue) {FactoryGirl.create :venue}
    before do
      sign_in FactoryGirl.create(:user)
      assign :venue, venue
    end

    it "show venue" do
      render
      expect(rendered).to include venue.name
      expect(rendered).to include venue.address_details
    end
  end
end
