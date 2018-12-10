# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Pull Request API', :type => :request do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  ##
  # Test variables
  #
  let(:pr) { create :pull_request }

  let(:source) { create :topic, :upstream => target }
  let(:target) { create :topic }

  let(:user) { create :user, :confirmed }

  let(:feedback) { Faker::Lorem.words(20).join ' ' }

  before do
    pr.source.collaborators << user
    pr.target.collaborators << user

    source.collaborators << user
  end

  ##
  # Request
  #
  let(:attributes) do
    {
      :message => Faker::Lorem.words(20).join(' ')
    }
  end

  def request_body(attributes)
    {
      :data => {
        :type => 'pullRequests',
        :attributes => attributes,
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
  describe 'POST /' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects empty message' do
      post pull_requests_path, :params => request_body(attributes.merge :message => ''), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    context 'when the source does not have an upstream' do
      let(:source) { create :topic }

      it 'rejects' do
        post pull_requests_path, :params => request_body(attributes), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    context 'when the source has an upstream not equal to the target' do
      let(:source) { create :topic, :upstream => create(:topic) }

      it 'rejects' do
        post pull_requests_path, :params => request_body(attributes), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    context 'when the source already has an open pull request' do
      before { create :pull_request, :source => source, :target => target }

      it 'rejects' do
        post pull_requests_path, :params => request_body(attributes), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    it 'returns successful' do
      post pull_requests_path, :params => request_body(attributes), :headers => headers

      expect(response.status).to eq 201
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body

      expect(json['data']['attributes']['message']).to eq attributes[:message]
    end
  end

  describe 'GET /:id' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects an invalid id' do
      get pull_request_path(:id => 0), :headers => headers

      expect(response.status).to eq 404
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'returns successful' do
      get pull_request_path(:id => pr.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end

  describe 'GET /incomingPullRequests' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'returns successful' do
      get topic_incomingPullRequests_path(:topic_id => pr.target.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body
      expect(json['data'].count).to eq 1
    end
  end

  describe 'GET /outgoingPullRequests' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'returns successful' do
      get topic_outgoingPullRequests_path(:topic_id => pr.source.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body
      expect(json['data'].count).to eq 1
    end
  end

  describe 'PUT/PATCH /:id' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects empty feedback' do
      patch pull_request_path(:id => pr.id), :params => update_body(pr.id, :state => 'rejected', :feedback => ''), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    context 'when the pull request is already accepted' do
      before { pr.accept }

      it 'rejects' do
        patch pull_request_path(:id => pr.id), :params => update_body(pr.id, :state => 'rejected', :feedback => feedback), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    context 'when the pull request is already rejected' do
      before { pr.rejected }

      it 'rejects' do
        patch pull_request_path(:id => pr.id), :params => update_body(pr.id, :state => 'rejected', :feedback => feedback), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
      end
    end

    it 'returns successful' do
      patch pull_request_path(:id => pr.id), :params => update_body(pr.id, :state => 'rejected', :feedback => feedback), :headers => headers

      expect(response.status).to eq 201
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body

      expect(json['data']['attributes']['feedback']).to eq feedback
      expect(json['data']['attributes']['state']).to eq 'rejected'

      pr.reload
      expect(pr).to be_rejected
    end
  end
end
