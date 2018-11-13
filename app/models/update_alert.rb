# frozen_string_literal: true

##
# An alert requiring the user's attention
#
class UpdateAlert < Alert
  ##
  # Properties
  #
  property :count

  ##
  # Associations
  #
  belongs_to :topic

  ##
  # Validations
  #
  validates :count,
            :presence => true,
            :numericality => { :only_integer => true }

  validate :alert_type_is_updated

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #
  def alert_type_is_updated
    errors.add :alert_type unless alert_type == 'topic_updated'
  end
end
