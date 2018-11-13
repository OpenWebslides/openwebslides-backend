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

  has_many :incoming_pull_requests,
           :class_name => 'PullRequest',
           :foreign_key => :target_id,
           :dependent => :destroy,
           :inverse_of => :target

  has_many :outgoing_pull_requests,
           :class_name => 'PullRequest',
           :foreign_key => :source_id,
           :dependent => :destroy,
           :inverse_of => :source

  ##
  # Validations
  #
  validates :title,
            :presence => true

  validates :state,
            :presence => true

  validates :root_content_item_id,
            :presence => true

  validate :upstream_cannot_be_fork

  validate :upstream_xor_forks

  ##
  # Callbacks
  #
  ##
  # Methods
  #

  # Find open outgoing pull request
  def pull_request
    outgoing_pull_requests.find(&:open?)
  end

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
  def upstream_cannot_be_fork
    # If upstream is set, it cannot reference a topic that is a fork too (where upstream is non-empty)
    errors.add :upstream, 'cannot be a fork' if upstream&.upstream
  end

  def upstream_xor_forks
    # Either `forks` or `upstream` can be set
    return unless upstream && forks.any?

    errors.add :upstream, 'cannot be non-empty when forks are specified'
    errors.add :forks, 'cannot be non-empty when upstream is specified'
  end
end
