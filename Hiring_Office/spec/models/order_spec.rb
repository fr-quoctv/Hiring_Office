require "rails_helper"

RSpec.describe Order, type: :model do
  context "associations" do
    it {is_expected.to belong_to :venue}
    it {is_expected.to belong_to :payment_method}
    it {is_expected.to have_one :payment}
    it {is_expected.to have_many :bookings}
  end

  describe "update_booking" do
    let(:booking) {FactoryGirl.create :booking, state: "requested"}
    let(:order) {FactoryGirl.create :order, booking_ids: booking.id.to_s}

    it "update success" do
      mock_booking = double "booking", order_id: order.id
      allow(booking).to receive(:update_attributes).and_return mock_booking
      expect(order.update_booking).to eq order.booking_ids
    end
  end
end
