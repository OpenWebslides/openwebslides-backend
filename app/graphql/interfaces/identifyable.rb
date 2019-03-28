# frozen_string_literal: true

module Interfaces
  module Identifyable
    include Interfaces::BaseInterface

    ##
    # Metadata
    #
    description 'An object that can be uniquely identified'

    ##
    # Attributes
    #
    field :id,
          ID,
          'Unique identifier',
          :null => false
  end
end
