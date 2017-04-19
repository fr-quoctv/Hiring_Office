require "rails_helper"

RSpec.describe RatingCache, type: :model do
  context "associations" do
    it {is_expected.to belong_to :cacheable}
  end
end
