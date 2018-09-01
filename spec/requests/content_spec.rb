# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content API', :type => :request do
  ##
  # Configuration
  #
  ##
  # Stubs and mocks
  #
  before do
    Stub::Command.create Repository::Read
    Stub::Command.create Repository::Update, %i[content= author= message=]
  end

  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  let(:message) { Faker::Lorem.words(4).join ' ' }

  ##
  # Request variables
  #
  def content_body(commit_msg = message)
    {
      :data => {
        :type => 'contents',
        :attributes => {
          :message => commit_msg,
          :content => [{
            :foo => 'bar'
          }]
        }
      }
    }.to_json
  end

  ##
  # Tests
  #
  describe 'GET /' do
    it 'returns topic content' do
      get topic_content_path(:topic_id => topic.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end

  describe 'PUT/PATCH /' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects update when no message is specified' do
      patch topic_content_path(:topic_id => topic.id), :params => content_body(nil), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end

    it 'updates topic content' do
      patch topic_content_path(:topic_id => topic.id), :params => content_body, :headers => headers

      expect(response.status).to eq 204
    end
  end
end
