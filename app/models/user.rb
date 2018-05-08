# frozen_string_literal: true

##
# A user account
#
class User < ApplicationRecord
  devise :database_authenticatable, :confirmable, :recoverable, :trackable, :validatable
  include JWT::Auth::Authenticatable

  ##
  # Properties
  #

  property :first_name
  property :last_name
  property :email
  property :locale
  property :token_version
  property :tos_accepted

  ##
  # Associations
  #
  has_many :identities,
           :dependent => :destroy

  has_many :topics,
           :dependent => :destroy,
           :inverse_of => :user

  has_many :grants,
           :dependent => :destroy

  has_many :collaborations,
           :class_name => 'Topic',
           :through => :grants,
           :source => :topic,
           :inverse_of => :collaborators

  has_many :notifications,
           :dependent => :destroy,
           :inverse_of => :user

  has_many :annotations,
           :dependent => :destroy,
           :inverse_of => :user

  has_many :ratings,
           :dependent => :destroy,
           :inverse_of => :user

  ##
  # Validations
  #
  validates :first_name,
            :presence => true

  validates :email,
            :presence => true,
            :format => { :with => /\A[^@]+@[^@]+\z/ },
            :uniqueness => true

  validates :locale,
            :presence => true,
            :inclusion => { :in => proc { I18n.available_locales.map(&:to_s) } }

  validates :token_version,
            :presence => true,
            :numericality => { :only_integer => true }

  validate :readonly_email, :on => :update

  validate :accepted_terms

  ##
  # Callbacks
  #
  before_create :create_email_identity
  after_initialize :set_default_locale

  ##
  # Methods
  #
  def self.find_by_token(params)
    user = find_by params
    return nil unless user
    raise JSONAPI::Exceptions::UnconfirmedError unless user.confirmed?
    user
  end

  def name
    last_name? ? "#{first_name} #{last_name}" : first_name
  end

  def increment_token_version
    self.token_version += 1
  end

  def increment_token_version!
    increment_token_version
    save!
  end

  ##
  # Overrides
  #
  def password=(new_password)
    increment_token_version
    super new_password
  end

  ##
  # Helpers and callback methods
  #
  def readonly_email
    errors.add :email, 'cannot be changed' if email_changed?
  end

  def accepted_terms
    return if tos_accepted?

    errors.add :tos_accepted, I18n.t('openwebslides.validations.user.tos_accepted')
  end

  private

  def create_email_identity
    identities.build :provider => 'email', :uid => email
  end

  def set_default_locale
    self.locale = 'en' if locale.blank?
  end
end
