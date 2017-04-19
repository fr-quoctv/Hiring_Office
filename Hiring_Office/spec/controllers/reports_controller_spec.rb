require "rails_helper"

RSpec.describe ReportsController, type: :controller do
  Venue.public_activity_off
  let(:user) {FactoryGirl.create :user}
  let(:venue) {FactoryGirl.create :venue}

  before(:each) do
    sign_in FactoryGirl.create(:user)
    allow(controller).to receive(:current_user) {user}
    request.env['HTTP_REFERER'] = root_url
  end

  describe "POST #create" do
    let :attributes_true do
      FactoryGirl.attributes_for :report, content: "report", venue_id: venue.id
    end
    let :attributes_false do
      FactoryGirl.attributes_for :report, content: nil, venue_id: venue.id
    end
    it "create successfully" do
      post :create, report: attributes_true
      expect(flash[:success]).to be_present
      response.should redirect_to :back
    end

    it "create failed" do
      post :create, report: attributes_false
      expect(flash[:danger]).to be_present
      response.should redirect_to :back
    end
  end
end
