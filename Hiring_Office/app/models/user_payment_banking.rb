class UserPaymentBanking < ApplicationRecord

  attr_accessor :order_payment

  has_one :order, as: :payment_detail
  has_many :notifications, as: :notifiable
  has_many :notifications, as: :receiver
  belongs_to :user

  enum status: {rejected: 0, pending: 1, accepted: 2}

  validates :card_name, presence: true
  validates :card_number, presence: true
  validates :card_address, presence: true
  validates :banking_name, presence: true
  validates :email, presence: true

  after_create :update_payment_method_of_order
  after_update :update_status_order
  before_update :check_status_without_accepted?

  def update_payment_method_of_order
    order_payment.update_attributes payment_detail_id: id,
      payment_detail_type: UserPaymentBanking.name
    owners = order_payment.venue.gets_owner
    owners.each do |owner|
      case
      when pending?
        notifications.create message: :requested, receiver: owner.user, owner_id: user.id
      end
    end
  end

  def update_status_order
    order_payment = Order.find_by payment_detail_id: id, payment_detail_type: UserPaymentBanking.name
    order_payment.update_attributes status: Order.statuses[:paid]
    owners = order_payment.venue.gets_owner
    owners.each do |owner|
      case
      when rejected?
        notifications.create message: :rejected, receiver: user, owner_id: owner.user.id
      when accepted?
        notifications.create message: :accepted, receiver: user, owner_id: owner.user.id
      end
    end
  end

  def check_status_without_accepted?
    !self.accepted?
  end
end
