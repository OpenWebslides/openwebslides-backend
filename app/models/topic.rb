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

  # Root content item identifier
  property :root_content_item_id

  ##
  # Associations
  #
  belongs_to :user,
             :inverse_of => :topics

  belongs_to :upstream,
             :optional => true,
             :class_name => 'Topic',
             :inverse_of => :forks

  has_many :forks,
           :class_name => 'Topic',
           :foreign_key => :upstream_id,
           :inverse_of => :upstream

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

  has_many :feed_items,
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
  validates :title,
            :presence => true

  validates :state,
            :presence => true

  validates :root_content_item_id,
            :presence => true

  ##
  # Callbacks
  #
  ##
  # Methods
  #
  ##
  # Overrides
  #

  # Override `content_id` and `content` to allow inclusion of abstract resource
  def content_id
    id
  end

  def content; end

  ##
  # Helpers and callback methods
  #
end
