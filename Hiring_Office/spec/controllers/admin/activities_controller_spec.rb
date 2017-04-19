require "rails_helper"

RSpec.describe Admin::ActivitiesController, type: :controller do
  before do
    sign_in FactoryGirl.create :admin
  end

  describe "GET #index" do
    it do
      get :index
      expect(response).to have_http_status :success
    end
  end
end
