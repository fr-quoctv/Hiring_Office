require "rails_helper"

RSpec.describe UserPaymentDirectly, type: :model do
  describe "associations" do
    it {is_expected.to have_many :orders}
  end

  describe "create order" do
    let(:booking) {FactoryGirl.create :booking}
    let(:order) {FactoryGirl.create :order, booking_ids: booking.id.to_s}
    let(:user_payment_directly) {FactoryGirl.create :user_payment_directly,
      order: order}

    it "update payment method after create order" do
      mock_order = double "order"
      mock_user_payment_directly = double "user_payment_directly", order: order
      allow(order).to receive(:update_attributes).and_return mock_order
      expect(allow(user_payment_directly).to receive(:update_attributes).and_return mock_user_payment_directly)
    end
  end
end
