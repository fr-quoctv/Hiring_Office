require "rails_helper"

RSpec.describe Admin::VenuesController, type: :controller do
  Venue.public_activity_off

  before do
    sign_in FactoryGirl.create :admin
  end

  let(:venue) {FactoryGirl.create :venue}
  let(:params_true) {FactoryGirl.attributes_for :venue, block: true}
  let(:params_fail) {FactoryGirl.attributes_for :venue, block: nil}

  describe "GET #index" do
    it do
      get :index
      expect(response).to have_http_status :success
    end

    context "total venues" do
      it {expect(Venue.count).not_to be_nil}
    end
  end

  describe "PATCH #update" do
    it "returns json if update successfully" do
      patch :update, id: venue, venue: params_true, format: :json
      expect(response.body).to eq ({message: I18n.t("success"), block_venue: 1}.to_json)
    end

    it "returns json if update fail" do
      patch :update, id: venue, venue: params_fail, format: :json
      expect(response.body).to eq ({message: I18n.t("failed")}.to_json)
    end

    it "find venue fail" do
      patch :update, id: 100, venue: params_true, format: :json
      expect(controller).to set_flash[:danger]
      response.should redirect_to admin_venues_path
    end
  end

  describe "GET show/:id" do
    it "show success" do
      get :show, id: venue.id
    end
  end
end
