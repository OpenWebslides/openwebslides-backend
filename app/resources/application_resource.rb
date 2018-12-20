# frozen_string_literal: true

##
# REST resource
#
class ApplicationResource < JSONAPI::Resource
  abstract

  ##
  # Properties
  #

  # List of lambdas taking meta options and a resource instance, and returning a hash
  class_attribute :metadata

  self.metadata = []

  ##
  # Callbacks
  #
  ##
  # Overrides
  #
  def fetchable_fields
    # Omit null values
    super.reject { |f| self.class._attributes.key?(f) && public_send(f).nil? }
  end

  def records_for(relation_name)
    record_or_records = @model.public_send(relation_name)
    relationship = self.class._relationships[relation_name]

    case relationship
    when JSONAPI::Relationship::ToOne
      record_or_records
    when JSONAPI::Relationship::ToMany
      ::Pundit.policy_scope!(context[:current_user], record_or_records)
    else
      raise "Unknown relationship type #{relationship.inspect}"
    end
  end

  def meta(options)
    super_meta = super options

    if self.class.metadata
      super_meta.merge self.class.metadata.map { |m| m.call options, self }.reduce({}, :merge)
    else
      super_meta
    end
  end

  class << self
    def records(options = {})
      ::Pundit.policy_scope!(options[:context][:user] || options[:context][:current_user], _model_class)
    end
  end

  ##
  # Methods
  #
end
