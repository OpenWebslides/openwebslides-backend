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
  ##
  # Callbacks
  #
  ##
  # Methods
  #
  ##
  # Overrides
  #
  def alert_type
    :topic_updated
  end

  ##
  # Helpers and callback methods
  #
end
