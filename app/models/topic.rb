# frozen_string_literal: true

##
# A slide topic
#
class Topic < ApplicationRecord
  ##
  # Properties
  #

  # Topic title
  property :name

  # Topic description
  property :description

  # Unique name
  property :canonical_name

  # Access level
  enum :state => %i[public_access protected_access private_access]

  ##
  # Associations
  #
  belongs_to :user,
             :required => true,
             :inverse_of => :topics

  has_many :grants,
           :dependent => :destroy

  has_many :collaborators,
           :through => :grants,
           :source => :user,
           :class_name => 'User',
           :inverse_of => :collaborations

  has_many :assets,
           :dependent => :destroy,
           :inverse_of => :topic

  has_many :notifications,
           :dependent => :destroy,
           :inverse_of => :topic

  has_many :annotations,
           :dependent => :destroy,
           :inverse_of => :topic

  has_many :conversations,
           :inverse_of => :topic

  ##
  # Validations
  #
  validates :name, :presence => true
  validates :state, :presence => true

  ##
  # Callbacks
  #
  before_save :generate_canonical_name

  ##
  # Methods
  #
  ##
  # Overrides
  #
  ##
  # Helpers and callback methods
  #

  private

  def generate_canonical_name
    return if canonical_name?

    self.canonical_name = Zaru.sanitize! "#{user.email.parameterize}-#{name.parameterize}"
    return unless self.class.exists? :canonical_name => canonical_name

    i = 1
    loop do
      i += 1
      candidate = "#{canonical_name}-#{i}"
      unless self.class.exists? :canonical_name => candidate
        self.canonical_name = candidate
        break
      end
    end
  end
end
