# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Alerts API', :type => :request do
  ##
  # Configuration
  #
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
  let(:alert) { create :update_alert, :user => user }

  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  ##
  # Request variables
  #
  def params
    {
      :include => 'user,topic,pullRequest,subject'
    }
  end

  def update_body(id, attributes)
    {
      :data => {
        :type => 'alerts',
        :id => id,
        :attributes => attributes
      }
    }.to_json
  end

  ##
  # Tests
  #
  describe 'GET /:id' do
    before { get alert_path(:id => id), :params => params, :headers => headers(:access) }

    let(:id) { alert.id }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end

    context 'when the alert_type is topic_updated' do
      let(:alert) { create :update_alert, :user => user, :alert_type => :topic_updated, :topic => topic }

      it { is_expected.to have_http_status :ok }

      it { is_expected.to have_record alert }
      it { is_expected.to have_id alert.id }
      it { is_expected.to have_attribute(:alertType).with_value 'topic_updated' }
      it { is_expected.to have_attribute(:count).with_value alert.count }
      it { is_expected.to have_relationship(:user).with_record user }
      it { is_expected.to have_relationship(:topic).with_record topic }
      it { is_expected.to have_relationship(:subject).is_empty }
      it { is_expected.to have_relationship(:pullRequest).is_empty }
    end

    context 'when the alert_type is pr_submitted' do
      let(:alert) { create :pull_request_alert, :user => user, :alert_type => :pr_submitted }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to have_attribute(:alertType).with_value 'pr_submitted' }
      it { is_expected.to have_relationship(:user).with_record alert.user }
      it { is_expected.to have_relationship(:topic).with_record alert.topic }
      it { is_expected.to have_relationship(:subject).with_record alert.subject }
      it { is_expected.to have_relationship(:pullRequest).with_record alert.pull_request }
    end

    context 'when the alert_type is pr_accepted' do
      let(:alert) { create :pull_request_alert, :user => user, :alert_type => :pr_accepted }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to have_attribute(:alertType).with_value 'pr_accepted' }
      it { is_expected.to have_relationship(:user).with_record alert.user }
      it { is_expected.to have_relationship(:topic).with_record alert.topic }
      it { is_expected.to have_relationship(:subject).with_record alert.subject }
      it { is_expected.to have_relationship(:pullRequest).with_record alert.pull_request }
    end

    context 'when the alert_type is pr_rejected' do
      let(:alert) { create :pull_request_alert, :user => user, :alert_type => :pr_rejected }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to have_attribute(:alertType).with_value 'pr_rejected' }
      it { is_expected.to have_relationship(:user).with_record alert.user }
      it { is_expected.to have_relationship(:topic).with_record alert.topic }
      it { is_expected.to have_relationship(:subject).with_record alert.subject }
      it { is_expected.to have_relationship(:pullRequest).with_record alert.pull_request }
    end
  end

  describe 'GET /' do
    before { get user_alerts_path(:user_id => user.id), :params => params, :headers => headers(:access) }

    prepend_before do
      create :update_alert, :user => user, :alert_type => :topic_updated
      create :pull_request_alert, :user => user, :alert_type => :pr_submitted
      create :pull_request_alert, :user => user, :alert_type => :pr_accepted
      create :pull_request_alert, :user => user, :alert_type => :pr_rejected

      create :update_alert, :user => create(:user), :alert_type => :topic_updated
    end

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_records user.alerts }
    it { is_expected.to have_record_count 4 }
  end

  describe 'PUT/PATCH /alerts/:id' do
    before { patch alert_path(:id => id), :params => update_body(id, :read => read), :headers => headers(:access) }

    let(:id) { alert.id }
    let(:read) { true }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_attribute(:read).with_value true }

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end

    context 'when the alert is already read' do
      let(:alert) { create :update_alert, :user => user, :read => true }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to have_attribute(:read).with_value true }
    end

    context 'when the request sets an alert to unread' do
      let(:read) { false }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end
  end
end
