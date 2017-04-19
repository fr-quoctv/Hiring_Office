class SuggestPaymentMethodsController < ApplicationController
  before_action :load_venue

  def create
    unless @venue.payment_methods.any?
      if @venue.gets_owner.pluck(:user_id).include? current_user.id
        current_user.venues.each do |venue|
          if venue.have_payment_method? && venue != @venue
            @payment_methods = venue.payment_methods
            ActiveRecord::Base.transaction do
              raise ActiveRecord::RecordNotSaved unless copy_payment_directly(@payment_methods) &&
                copy_payment_banking(@payment_methods) && copy_paypals(@payment_methods)
            end
          end
        end
      end
    end
    redirect_to edit_venue_venue_market_path
  end

  private
  def load_venue
    @venue = Venue.find_by id: params[:venue_id]
    unless @venue
      flash[:danger] = t "flash.danger_message"
      redirect_to root_url
    end
    @venue_market = VenueMarketForm.new @venue
  end

  def copy_payment_directly payment_methods
    unless @venue.directly.any? || payment_methods.directly.blank?
      payment_directly = payment_methods.find_by payment_type:
        Settings.payment_methods.directly
      directly_old = Directly.find_by payment_method: payment_directly
      directly = Directly.create directly_old.attributes.symbolize_keys
        .except(:created_at, :updated_at, :id)
        .merge payment_method_id: nil, venue: @venue, pending_time: directly_old.pending_time
      return false unless directly
    end
    return true
  end

  def copy_payment_banking payment_methods
    unless @venue.banking.any? || payment_methods.banking.blank?
      payment_banking = payment_methods.find_by payment_type:
        Settings.payment_methods.banking
      banking_old = Banking.find_by payment_method: payment_banking
      banking = Banking.create banking_old.attributes.symbolize_keys
        .except(:created_at, :updated_at, :id)
        .merge payment_method_id: nil, venue: @venue, pending_time: banking_old.pending_time
      return false unless banking
    end
    return true
  end

  def copy_paypals payment_methods
    unless payment_methods.paypal.blank?
      payment_methods.paypal.order_by_updated.each do |payment|
        if payment.is_chosen? && !@venue.payment_methods.paypal.pluck(:email).include?(payment.email)
          payment_method = @venue.payment_methods.create payment.attributes.symbolize_keys
            .except(:created_at, :updated_at, :id)
          return false unless payment_method
          if @venue.payment_methods.paypal.pluck(:is_chosen).include?(true) &&
            @venue.payment_methods.paypal.count > Settings.number_is_chosen
            payment_method.update_attributes is_chosen: false
          end
        end
      end
    end
    return true
  end
end
