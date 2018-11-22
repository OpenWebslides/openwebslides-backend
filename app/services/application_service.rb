# frozen_string_literal: true

##
# Abstract service
#
class ApplicationService
  ##
  # Call a service with parameters
  #
  def self.call(*args, &block)
    new.call *args, &block
  end
end
