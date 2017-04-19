class Order < ApplicationRecord
  include RecordFindingByTime

  after_create :update_booking, :send_notification

  attr_accessor :booking_ids

  acts_as_paranoid
  
  belongs_to :coupon
  belongs_to :venue, -> {with_deleted}
  belongs_to :user
  belongs_to :payment_detail, polymorphic: true

  has_one :paypal

  has_many :bookings, dependent: :destroy
  has_many :directly
  has_many :notifications, as: :notifiable

  delegate :name, to: :user, prefix: true, allow_nil: true

  enum status: {requested: 0, pending: 1, paid: 2, closed: 3}

  scope :have_order_payment_directly, -> do
    where payment_detail_type: UserPaymentDirectly.name
  end

  scope :have_order_payment_banking, -> do
    where payment_detail_type: UserPaymentBanking.name
  end

  scope :order_has_payment_type, -> do
    where.not payment_detail_type: nil
  end

  scope :recent, ->{order :created_at}

  scope :filter_by_payment_detail, ->payment_detail_type do
    where payment_detail_type: payment_detail_type if payment_detail_type.present?
  end

  scope :filter_by_status, ->status do
    where status: status if status.present?
  end

  scope :group_created_at_by_date, -> {group "date(created_at)"}

  scope :total_revenue_of_venue, -> venue_id do
    where(venue_id: venue_id).sum :total_paid
  end

  after_update :delete_paypal_after_change_method
  after_update :checktime_to_reject

  def delete_paypal_after_change_method
    if self.payment_detail_type != Paypal
      self.paypal.destroy if self.paypal
    end
  end

  def update_booking
    @booking_ids = booking_ids.split(" ")
    @booking_ids.each do |booking_id|
      booking = Booking.find_by id: booking_id
      booking.update_attributes order_id: self.id, state: "requested"
    end
  end

  def auto_reject_order
    if self.status != Order.statuses[:paid]
      date = self.updated_at + self.payment_detail.pending_time.hours
      if date < Time.current
        self.update_attributes status: Order.statuses[:closed]
        self.bookings.each do |booking|
          booking.update_attributes state: Booking.states[:rejected]
        end
      end
    end
  end

  def send_notification
    owners = self.venue.gets_owner
    owners.each do |owner|
      case
      when pending?
        notifications.create message: :requested, receiver: owner.user, owner_id: user_id
      end
    end
  end

  def checktime_to_reject
    if self.payment_detail_type && self.payment_detail_type != Settings
      .payment_methods_filter.paypal
      delay(run_at: calculate_delay_time.minutes.from_now)
        .auto_reject_order
    end
  end

  def load_email_paypal
    self.venue.payment_methods.paypal.find_by is_chosen: true
  end

  def find_payment_banking
    self.venue.payment_methods.banking
  end

  def find_payment_directly
    self.venue.payment_methods.directly
  end

  def find_information_banking_account
    self.venue.banking.with_deleted.find_by verified: true
  end

  def find_directly_info
    self.venue.directly.with_deleted.find_by verified: true
  end

  private
  def calculate_delay_time
    Common.mul_60(self.payment_detail.pending_time) + Settings.delay_time
  end
end
