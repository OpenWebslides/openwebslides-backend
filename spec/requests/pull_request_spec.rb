# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pull Request API', :type => :request do
  ##
  # Configuration
  #
  include_context 'repository'

  ##
  # Stubs and mocks
  #
  ##
  # Subject
  #
  subject { response }

  ##
  # Test variables
  #
  let(:pr) { create :pull_request, :state => 'ready' }

  let(:source) { create :topic, :upstream => target }
  let(:target) { create :topic }

  let(:user) { create :user, :confirmed }

  ##
  # Request variables
  #
  def params
    {
      :include => 'user,source,target'
    }
  end

  def create_body(message)
    {
      :data => {
        :type => 'pullRequests',
        :attributes => { :message => message },
        :relationships => {
          :user => {
            :data => {
              :id => user.id,
              :type => 'users'
            }
          },
          :source => {
            :data => {
              :id => source.id,
              :type => 'topics'
            }
          },
          :target => {
            :data => {
              :id => target.id,
              :type => 'topics'
            }
          }
        }
      }
    }.to_json
  end

  def update_body(id, attributes)
    {
      :data => {
        :type => 'pullRequests',
        :id => id,
        :attributes => attributes
      }
    }.to_json
  end

  ##
  # Tests
  #
  before do
    Repo::Create.call source
    Repo::Create.call target

    pr.source.collaborators << user
    pr.target.collaborators << user

    source.collaborators << user unless source.collaborators.include?(user)
  end

  describe 'POST /' do
    before { post pull_requests_path, :params => create_body(message), :headers => headers(:access) }

    let(:message) { Faker::Lorem.words(20).join ' ' }

    it { is_expected.to have_http_status :created }
    it { is_expected.to have_jsonapi_attribute(:message).with_value message }

    context 'when the message is empty' do
      let(:message) { '' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the source does not have an upstream' do
      let(:source) { create :topic }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the source has an upstream not equal to the target' do
      let(:source) { create :topic, :upstream => create(:topic) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the source already has a ready pull request' do
      let(:pr) { create :pull_request, :source => source, :target => target, :state => 'ready' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end
  end

  describe 'GET /:id' do
    before { get pull_request_path(:id => id), :params => params, :headers => headers(:access) }

    let(:id) { pr.id }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_record pr }
    it { is_expected.to have_jsonapi_relationship(:user).with_record pr.user }
    it { is_expected.to have_jsonapi_relationship(:source).with_record pr.source }
    it { is_expected.to have_jsonapi_relationship(:target).with_record pr.target }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end
  end

  describe 'GET /incomingPullRequests' do
    before { get topic_incomingPullRequests_path(:topic_id => pr.target.id), :headers => headers(:access) }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_records pr.target.incoming_pull_requests }
    it { is_expected.to have_jsonapi_record_count 1 }
  end

  describe 'GET /outgoingPullRequests' do
    before { get topic_outgoingPullRequests_path(:topic_id => pr.source.id), :headers => headers(:access) }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_records pr.source.outgoing_pull_requests }
    it { is_expected.to have_jsonapi_record_count 1 }
  end

  describe 'PUT/PATCH /:id' do
    before { patch pull_request_path(:id => pr.id), :params => update_body(pr.id, :stateEvent => 'reject', :feedback => feedback), :headers => headers(:access) }

    let(:feedback) { Faker::Lorem.words(20).join ' ' }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_jsonapi_record pr }
    it { is_expected.to have_jsonapi_attribute(:state).with_value 'rejected' }
    it { is_expected.to have_jsonapi_attribute(:feedback).with_value feedback }

    context 'when the feedback is empty' do
      let(:feedback) { '' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the pull request is pending' do
      let(:pr) { create :pull_request, :state => 'pending' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the pull request is incompatible' do
      let(:pr) { create :pull_request, :state => 'incompatible' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the pull request is working' do
      let(:pr) { create :pull_request, :state => 'working' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the pull request is already accepted' do
      let(:pr) { create :pull_request, :state => 'accepted', :feedback => 'feedback' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end

    context 'when the pull request is already rejected' do
      let(:pr) { create :pull_request, :state => 'rejected', :feedback => 'feedback' }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_jsonapi_error.with_code JSONAPI::VALIDATION_ERROR }
    end
  end
end
