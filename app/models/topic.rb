# frozen_string_literal: true

##
# A slide topic
#
class Topic < ApplicationRecord
  ##
  # Properties
  #

  # Topic title
  attribute :title

  # Topic description
  attribute :description

  # Root content item identifier
  attribute :root_content_item_id

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

  has_many :alerts,
           :dependent => :destroy,
           :inverse_of => :topic

  ##
  # Validations
  #
  validates :title,
            :length => { :maximum => 100 },
            :presence => true

  validates :description,
            :length => { :maximum => 200 }

  validates :access,
            :presence => true

  validates :root_content_item_id,
            :presence => true

  validate :upstream_cannot_be_fork

  validate :upstream_xor_forks

  validate :more_permissive_upstream

  ##
  # State
  #
  state_machine :access, :initial => :public do
    state :public
    state :private
    state :protected

    # Make a topic private
    event :set_private do
      transition :public => :private,
                 :protected => :private
    end

    # Make a topic protected
    event :set_protected do
      transition :public => :protected,
                 :private => :protected
    end

    # Make a topic public
    event :set_public do
      transition :protected => :public,
                 :private => :public
    end
  end

  ##
  # Callbacks
  #
  ##
  # Methods
  #

  # Find read outgoing pull request
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
    errors.add :upstream, I18n.t('openwebslides.validations.topic.upstream_cannot_be_fork') if upstream&.upstream
  end

  def upstream_xor_forks
    # Either `forks` or `upstream` can be set
    return unless upstream && forks.any?

    errors.add :upstream, I18n.t('openwebslides.validations.topic.upstream_xor_forks')
    errors.add :forks, I18n.t('openwebslides.validations.topic.upstream_xor_forks')
  end

  # Forked topics cannot be more permissive than their upstream
  def more_permissive_upstream
    return unless upstream

    # Add error in case of (public and upstream is protected/private),
    # or (public/protected and upstream is private)
    return unless (public? && !upstream.public?) || (!private? && upstream.private?)

    errors.add :access, I18n.t('openwebslides.validations.topic.more_permissive_upstream')
  end
end
