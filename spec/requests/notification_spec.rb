# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notification API', :type => :request do
  let(:notification) { create :notification }

  describe 'GET /' do
    before do
    end

    it 'returns a list of all notifications' do
      create :notification
      get notifications_path, :headers => headers

      expect(response.status).to eq 200
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      json = JSON.parse response.body
      expect(json).to include 'data'
      expect(json['data']).to be_an Array
      expect(json['data']).not_to be_empty

      notification = json['data'].first
      expect(notification).to include 'attributes'
      expect(notification['attributes']).to include 'eventType'
      expect(notification['attributes']).to include 'userName'
      expect(notification['attributes']).to include 'topicTitle'
      expect(notification['meta']).to include 'createdAt'
    end
  end
end
