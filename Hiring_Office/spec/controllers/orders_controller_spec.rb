require "rails_helper"

RSpec.describe OrdersController, type: :controller do
  let(:venue) {FactoryGirl.create :venue}
  let(:booking) {FactoryGirl.create :booking}

  describe "POST #create" do
    it "Create a new Order successfully" do
      expect{ xhr :post, :create, {venue_id: venue.id, booking_ids: booking.id,
        order: FactoryGirl.attributes_for(:order)}}
        .to change(Order, :count).by(1)
    end

    it "Does not create new Order successfully" do
      mocked_order = double "order"
      allow(Order).to receive(:new).and_return mocked_order
      allow(mocked_order).to receive(:save).and_return false
      expect{ xhr :post, :create, {venue_id: venue.id, booking_ids: booking.id,
        order: FactoryGirl.attributes_for(:order)}}
        .not_to change(Order, :count)
    end
  end
end
