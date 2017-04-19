require "rails_helper"

RSpec.describe VenueAmenity, type: :model do
  context "associations" do
    it {is_expected.to belong_to :venue}
    it {is_expected.to belong_to :amenity}
  end
  describe "scopes" do
    let(:user_role_venue) {FactoryGirl.create :user_role_venue}
    let(:venue_amenity) {FactoryGirl.create :venue_amenity}
    it "find_by_amenity_and_venue" do
      user_role_venue
      expect(VenueAmenity.find_by_amenity_and_venue venue_amenity.venue,
        venue_amenity.amenity).to eq(venue_amenity)
    end
  end
end
