# frozen_string_literal: true

##
# REST resource
#
class ApplicationResource < JSONAPI::Resource
  abstract

  ##
  # Properties
  #
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

  class << self
    def records(options = {})
      ::Pundit.policy_scope!(options[:context][:user] || options[:context][:current_user], _model_class)
    end
  end

  ##
  # Methods
  #
  ##
  # Metadata
  #
  # JSONAPI::Resources allows specifying a `meta` method to allow defining metadata on a resource.
  # In order to use composable metadata, every class descended from ApplicationResource will have
  # a `metadata` attribute, containing an array of lambdas taking two arguments: `options` and `resource`.
  # On resource serialization, these lambdas will be called and merged into the meta object.
  #
  # Please note that the setters (`+=`) should be used on the attribute to ensure the correct
  # operation of Rails' `class_attribute`.
  #
  class_attribute :metadata

  # Initialize to empty array
  self.metadata = []

  # Merge all metadata into a meta object
  def meta(options)
    super_meta = super options

    if self.class.metadata
      metadata = self.class.metadata
                     .map { |m| m.call options, self }
                     .reduce({}, :merge)
                     .transform_keys { |k| options[:serializer].key_formatter.format k }

      super_meta.merge metadata
    else
      super_meta
    end
  end
end
