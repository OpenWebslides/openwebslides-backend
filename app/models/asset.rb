# frozen_string_literal: true

##
# A binary asset
#
class Asset < ApplicationRecord
  ##
  # Properties
  #

  # Relative path to asset file
  attribute :filename

  ##
  # Associations
  #
  belongs_to :topic,
             :inverse_of => :assets

  ##
  # Validations
  #
  validates :filename,
            :presence => true,
            :uniqueness => { :scope => :topic }

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

  ##
  # A short-lived JWT to fetch an asset
  #
  class Token < JWT::Auth::Token
    attr_accessor :object

    def type
      :asset
    end

    def lifetime
      JWT::Auth.access_token_lifetime
    end

    def valid?
      object&.reload

      super && !object.nil?
    end

    def payload
      super.merge :obj => object.id
    end

    class << self
      def parse(payload)
        # Use #find_by instead of #find to prevent RecordNotFound errors being raised
        super.merge :object => Asset.find_by(:id => payload['obj'])
      end

      def token_for(type)
        case type
        when 'asset'
          Asset::Token
        else
          super type
        end
      end
    end
  end
end
