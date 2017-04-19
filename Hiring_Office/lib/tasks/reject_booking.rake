namespace :update do
  desc "Auto reject"
  task booking: :environment do
    Space.all.each do |space|
      date = Time.current + space.day_reject.days
      Booking.load_resourse_to_reject(date).each do |booking|
        booking.update_attributes state: Booking.states["rejected"]
        if booking.order
          booking.order.update_attributes status: Order.statuses["closed"]
        end
      end
    end
  end
end
