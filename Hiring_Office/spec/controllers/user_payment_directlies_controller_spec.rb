require "rails_helper"

RSpec.describe UserPaymentDirectliesController, type: :controller do

  describe "POST #create" do
    let(:venue) {FactoryGirl.create :venue}
    let(:booking) {FactoryGirl.create :booking}
    let(:order) {FactoryGirl.create :order, booking_ids: booking.id.to_s}

    it "user payment directlies create success" do
      expect {post :create, {venue_id: venue.id, order_id: order.id,
        user_payment_directly: FactoryGirl.attributes_for(:user_payment_directly)}}
        .to change(UserPaymentDirectly, :count).by(1)
    end

    it "user payment directlies does not create success" do
      post :create, {venue_id: venue.id, order_id: order.id,
        user_payment_directly: FactoryGirl.attributes_for(:user_payment_directly, email: nil)}
      expect(flash[:danger]).to_not be_empty
    end
  end
end
