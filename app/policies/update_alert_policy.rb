# frozen_string_literal: true

class UpdateAlertPolicy < AlertPolicy
  ##
  # Resource
  #
  ##
  # Relationship: topic
  #
  def show_topic?
    # Users can only show topic if the alert is showable
    # Authorize the user separately in the controller
    show?
  end

  ##
  # Scope
  #
  class Scope < Scope; end
end
