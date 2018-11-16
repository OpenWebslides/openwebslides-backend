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
  # Test variables
  #
  let(:alert) { create :update_alert, :user => user }

  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

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
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects an invalid id' do
      get alert_path(:id => 0), :headers => headers

      expect(response.status).to eq 404
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    context 'when the alert_type is `topic_updated`' do
      let(:alert) { create :update_alert, :user => user, :alert_type => :topic_updated, :topic => topic }

      it 'returns successful' do
        get alert_path(:id => alert.id), :params => params, :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        json = JSON.parse(response.body)['data']

        expect(json['attributes']['alertType']).to eq 'topic_updated'
        expect(json['attributes']['count']).to eq alert.count
        expect(json['relationships']['user']['data']['id']).to eq user.id.to_s
        expect(json['relationships']['topic']['data']['id']).to eq topic.id.to_s
        expect(json['relationships']['subject']['data']).to be_nil
        expect(json['relationships']['pullRequest']['data']).to be_nil
      end
    end

    context 'when the alert_type is `pr_submitted`' do
      let(:alert) { create :pull_request_alert, :user => user, :alert_type => :pr_submitted }

      it 'returns successful' do
        get alert_path(:id => alert.id), :params => params, :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        json = JSON.parse(response.body)['data']

        expect(json['attributes']['alertType']).to eq 'pr_submitted'
        expect(json['relationships']['user']['data']['id']).to eq alert.user.id.to_s
        expect(json['relationships']['topic']['data']['id']).to eq alert.topic.id.to_s
        expect(json['relationships']['subject']['data']['id']).to eq alert.subject.id.to_s
        expect(json['relationships']['pullRequest']['data']['id']).to eq alert.pull_request.id.to_s
      end
    end

    context 'when the alert_type is `pr_accepted`' do
      let(:alert) { create :pull_request_alert, :user => user, :alert_type => :pr_accepted }

      it 'returns successful' do
        get alert_path(:id => alert.id), :params => params, :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        json = JSON.parse(response.body)['data']

        expect(json['attributes']['alertType']).to eq 'pr_accepted'
        expect(json['relationships']['user']['data']['id']).to eq alert.user.id.to_s
        expect(json['relationships']['topic']['data']['id']).to eq alert.topic.id.to_s
        expect(json['relationships']['subject']['data']['id']).to eq alert.subject.id.to_s
        expect(json['relationships']['pullRequest']['data']['id']).to eq alert.pull_request.id.to_s
      end
    end

    context 'when the alert_type is `pr_rejected`' do
      let(:alert) { create :pull_request_alert, :user => user, :alert_type => :pr_rejected }

      it 'returns successful' do
        get alert_path(:id => alert.id), :params => params, :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        json = JSON.parse(response.body)['data']

        expect(json['attributes']['alertType']).to eq 'pr_rejected'
        expect(json['relationships']['user']['data']['id']).to eq alert.user.id.to_s
        expect(json['relationships']['topic']['data']['id']).to eq alert.topic.id.to_s
        expect(json['relationships']['subject']['data']['id']).to eq alert.subject.id.to_s
        expect(json['relationships']['pullRequest']['data']['id']).to eq alert.pull_request.id.to_s
      end
    end
  end

  describe 'GET /' do
    before do
      add_content_type_header
      add_auth_header

      create :update_alert, :user => user, :alert_type => :topic_updated
      create :pull_request_alert, :user => user, :alert_type => :pr_submitted
      create :pull_request_alert, :user => user, :alert_type => :pr_accepted
      create :pull_request_alert, :user => user, :alert_type => :pr_rejected
    end

    it 'returns successful' do
      get user_alerts_path(:user_id => user.id), :params => params, :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body
      expect(json['data'].count).to eq 4

      expect(json['data'][0]['attributes']['alertType']).to eq 'topic_updated'
      expect(json['data'][1]['attributes']['alertType']).to eq 'pr_submitted'
      expect(json['data'][2]['attributes']['alertType']).to eq 'pr_accepted'
      expect(json['data'][3]['attributes']['alertType']).to eq 'pr_rejected'
    end
  end

  describe 'PUT/PATCH /alerts/:id' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects non-existant alerts' do
      patch alert_path(:id => 999), :params => update_body(999, :read => true), :headers => headers

      expect(response.status).to eq 404
      expect(jsonapi_error_code(response)).to eq JSONAPI::RECORD_NOT_FOUND
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    context 'when the alert is not read' do
      let(:alert) { create :update_alert, :user => user, :read => false }

      it 'rejects requests with read set to false' do
        patch alert_path(:id => alert.id), :params => update_body(alert.id, :read => false), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        alert.reload
        expect(alert.read).to be false
      end

      it 'sets read to true' do
        patch alert_path(:id => alert.id), :params => update_body(alert.id, :read => true), :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        alert.reload
        expect(alert.read).to be true
      end
    end

    context 'when the alert is already read' do
      let(:alert) { create :update_alert, :user => user, :read => true }

      it 'rejects requests with read set to false' do
        patch alert_path(:id => alert.id), :params => update_body(alert.id, :read => false), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        alert.reload
        expect(alert.read).to be true
      end

      it 'sets read to true' do
        patch alert_path(:id => alert.id), :params => update_body(alert.id, :read => true), :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

        alert.reload
        expect(alert.read).to be true
      end
    end
  end
end
