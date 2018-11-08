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
  let(:alert) { create :alert, :user => user }

  let(:user) { create :user, :confirmed }

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

    it 'returns successful' do
      get alert_path(:id => alert.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"
    end
  end

  describe 'GET /' do
    before do
      add_content_type_header
      add_auth_header

      create_list :alert, 3, :user => user
    end

    it 'returns successful' do
      get user_alerts_path(:user_id => user.id), :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}"

      json = JSON.parse response.body
      expect(json['data'].count).to eq 3
    end
  end
end
