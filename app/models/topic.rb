# frozen_string_literal: true

##
# A slide topic
#
class Topic < ApplicationRecord
  ##
  # Properties
  #

  # Topic title
  property :title

  # Topic description
  property :description

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
  validates :title, :presence => true
  validates :state, :presence => true

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
end
