require "rails_helper"
include GeneralHelper

RSpec.describe Booking, type: :model do
  context "associations" do
    it {is_expected.to belong_to :user}
    it {is_expected.to belong_to :space}
    it {is_expected.to belong_to :booking_type}
    it {is_expected.to have_one :invoice}
    it {is_expected.to have_many :notifications}
  end

  context "validates" do
    it {is_expected.to validate_presence_of :booking_from}
    it {is_expected.to validate_presence_of :duration}
    it {is_expected.to validate_presence_of :quantity}
    it {is_expected.to validate_presence_of :user}
  end

  describe "scopes" do
    let(:booking) {FactoryGirl.create :booking, order_id: nil,
      state: Settings.requested, created_at: "2016-11-24 08:59:27"}
    let(:order) {FactoryGirl.create :order, booking_ids: booking.id.to_s}

    it "without_order scope" do
      expect(Booking.without_order).to include booking
    end

    it "have_order scope" do
      expect(Booking.have_order).not_to include booking
    end

    it "by_date scope" do
      mock_booking = double "booking", created_at: "2016-11-24 08:59:29"
      booking_array = [mock_booking, booking]
      allow(Booking).to receive(:by_date).and_return booking_array
      expect(Booking.by_date).to eq booking_array
    end

    it "group_by_order scope" do
      allow(order).to receive(:update_booking).and_return booking
      mock_booking = double "booking", order: order
      allow(booking).to receive(:update).and_return mock_booking
      mock_state_array = [[order, order.bookings]].to_h
      expect(Booking.group_by_order "requested").to eq mock_state_array
    end

    it "load_resourse_to_reject scope" do
      mock_booking = double "booking", state: Settings.requested,
        created_at: "2016-11-24 08:59:29", booking_from: "2016-11-29"
      booking.stub(:update).and_return mock_booking
      Date.stub(:today).and_return("2016-11-29".to_date)
      date = Date.today
      expect(Booking.load_resourse_to_reject(date)).to include booking
    end
  end

  describe "others method" do
    let(:booking_type) {FactoryGirl.create :booking_type}
    let(:space) {FactoryGirl.create :space}
    let(:price) {FactoryGirl.create :price, space: space,
      booking_type: booking_type}
    let(:booking) {FactoryGirl.create :booking, space: space,
      booking_type: booking_type}
    let(:order) {FactoryGirl.create :order, booking_ids: booking.id.to_s}

    it "total_price method" do
      allow(booking_type).to receive(:save).and_return booking_type
      allow(space).to receive(:save).and_return space
      allow(price).to receive(:save).and_return price
      allow(booking).to receive(:save).and_return booking
      total = select_price(booking.space, booking_type.id)*booking.quantity
      expect(booking.total_price).to eq total
    end

    it "order_referenced_with_booking" do
      allow(Order).to receive(:find_by).and_return order
      mock_order = double "order", deleted_at: Time.current
      allow(order.bookings).to receive(:any?).and_return false
      allow(order).to receive(:update_attributes).and_return mock_order
      expect(booking.order_referenced_with_booking).to eq mock_order
    end
  end
end
