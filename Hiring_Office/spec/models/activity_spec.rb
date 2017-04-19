require "rails_helper"

RSpec.describe Activity, type: :model do

  describe "get list activity" do
    let!(:activity1) {FactoryGirl.create :activity, created_at: Time.now}
    let!(:activity2) {FactoryGirl.create :activity, created_at: Time.now + 1.hours}
    let!(:activity3) {FactoryGirl.create :activity, created_at: Time.now + 2.hours}

    it "returns list order activities" do
      expect(Activity.order_desc).to eq [activity3, activity2, activity1]
    end
  end
end
