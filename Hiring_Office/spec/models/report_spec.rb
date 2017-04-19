require "rails_helper"

RSpec.describe Report, type: :model do
  Venue.public_activity_off
  context "associations" do
    it {is_expected.to belong_to :user}
    it {is_expected.to belong_to :venue}
    it {is_expected.to have_many :notifications}
  end

  context "validates" do
    it {is_expected.to validate_presence_of :content}
  end
  
  describe "send_notification" do
    let!(:venue) {FactoryGirl.create :venue}
    let!(:user) {FactoryGirl.create :user}
    let!(:admin) {FactoryGirl.create :admin}
    let!(:report) {FactoryGirl.create :report}
    notifications = Notification.create(message: "reported", notifiable_id: 1, 
      notifiable_type: Report.name, receiver_type: Admin.name, receiver_id: 1, owner_id: 1)
    it "return notifications" do
      expect(notifications).to be_present
    end
  end
end
