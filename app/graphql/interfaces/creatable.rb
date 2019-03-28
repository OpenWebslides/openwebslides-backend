# frozen_string_literal: true

module Interfaces
  module Creatable
    include Interfaces::BaseInterface

    ##
    # Metadata
    #
    description 'An object that has a creation timestamp'

    ##
    # Attributes
    #
    field :created_at,
          Integer,
          'Timestamp of creation',
          :null => false
  end
end
