class UserRoleVenue < ApplicationRecord
  acts_as_paranoid
  attr_accessor :old_owner

  belongs_to :user
  belongs_to :venue

  validates :user_id, presence: true
  validates :type_role, presence: true

  enum type_role: {owner: 1, manager: 2, client_service: 3, reception: 4}

  scope :find_owner_role_venue, -> venue_id {where venue_id: venue_id, type_role: :owner}
  scope :find_of_user, -> user_id {where user_id: user_id}
  scope :find_owner_role, -> {where type_role: :owner}

  delegate :email, to: :user

  before_create :update_current_owner_role, if: :old_owner

  def update_current_owner_role
    if self.type_role == Settings.owner
      current_roles = self.old_owner.user_role_venues.find_by venue_id: venue_id
      current_roles.update_attributes type_role: Settings.manager if current_roles
    end
  end

end
