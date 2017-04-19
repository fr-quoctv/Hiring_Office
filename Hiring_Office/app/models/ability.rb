class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    user.user_role_venues.each do |user_role_venue|
      case
      when user_role_venue.owner?
        can :manage, UserRoleVenue, venue_id: user_role_venue.venue.id
        can :manage, Space, venue_id: user_role_venue.venue.id
        can :manage, Venue, id: user_role_venue.venue.id
      when user_role_venue.manager?
        can :read, UserRoleVenue, venue_id: user_role_venue.venue.id
        can :manage, Space, venue_id: user_role_venue.venue.id
        can :manage, Venue, id: user_role_venue.venue.id
      when user_role_venue.client_service?
        can :read, [UserRoleVenue, Venue], venue_id: user_role_venue.venue.id
        can :manage, Space, venue_id: user_role_venue.venue.id
      when user_role_venue.reception?
        can :read, [Space, UserRoleVenue, Venue], venue_id: user_role_venue.venue.id
      end
    end
  end
end
