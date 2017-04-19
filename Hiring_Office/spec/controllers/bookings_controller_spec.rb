require "rails_helper"

RSpec.describe BookingsController, type: :controller do
  let(:user) {FactoryGirl.create(:user)}
  let(:booking_type) {FactoryGirl.create(:booking_type)}
  let(:space) {FactoryGirl.create :space, venue: venue}
  let(:venue) {FactoryGirl.create :venue}

  before do
    sign_in FactoryGirl.create(:user)
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "reture succress created" do
      xhr :post, :create, {booking: {space: create(:space),
        booking_from: Date.tomorrow, duration: 2, quantity: 1}}
      expect(Booking.count).to eq(1)
    end

    it "reture fail created" do
      xhr :post, :create, {booking: {space: create(:space)}}
      expect(Booking.count).to eq(0)
    end
  end

  describe "PUT #update" do
    let(:booking) {FactoryGirl.create :booking, user: user,
      booking_type: booking_type, space: space, state: "pending"}

    it "action booking update state success" do
      xhr :put, :update, {id: booking, state: "requested"}
    end

    it "action booking update message success" do
      xhr :put, :update, {id: booking, message: "pending"}
      expect(flash[:success]).not_to be_empty
    end

    it "action booking update message unsuccess" do
      xhr :put, :update, params: {state: "pending", id: booking}
      expect(response).to have_http_status(:success)
    end
  end

  describe "DELETE #destroy" do
    let(:booking) {FactoryGirl.create :booking, user: user,
      booking_type: booking_type, space: space, state: "pending"}

    it "the action delete booking success" do
      xhr :delete, :destroy, {id: booking}
      expect{to change(Booking, :count).by(-1)}
    end
  end
end
