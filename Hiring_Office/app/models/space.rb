class Space < ApplicationRecord
  include RecordFindingByTime
  include PublicActivity::Model

  tracked owner: Proc.new{|controller, model| controller.current_user}

  acts_as_paranoid
  ratyrate_rateable Settings.rate
  belongs_to :venue, -> {with_deleted}
  has_one :address, through: :venue

  has_many :images, as: :imageable
  has_many :bookings, dependent: :destroy
  has_many :prices, dependent: :destroy
  has_many :coupons, dependent: :destroy
  has_many :booking_types, through: :prices
  has_many :reviews, as: :reviewable, dependent: :destroy

  enum space_type: {desk: 0, prive_office: 1, meeting_room: 2, coworking_space: 3}

  validates :name, presence: true
  validates :space_type, presence: true
  validates :area, presence: true, numericality: {greater_than: 0}
  validates :day_reject, numericality: {greater_than: 0}
  validates :day_reject, presence: true, on: :update
  validates :capicity, presence: true, numericality: {greater_than: 0}
  validates :quantity, presence: true, numericality: {greater_than: 0}

  accepts_nested_attributes_for :images, allow_destroy: true
  accepts_nested_attributes_for :prices, allow_destroy: true
  accepts_nested_attributes_for :venue, allow_destroy: true

  delegate :name, to: :venue, prefix: true, allow_nil: true
  delegate :description, to: :venue, prefix: true, allow_nil: true
  delegate :details, to: :address, prefix: true, allow_nil: true

  scope :ids_of_venue, -> venue_id do
    where(venue_id: venue_id).pluck :id
  end

  def price_per_day
    prices.find_by booking_type: type_day
  end

  private
  def type_day
    BookingType.all.find_by name: Settings.booking_type.day
  end
end
