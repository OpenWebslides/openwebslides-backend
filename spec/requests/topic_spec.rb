# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Topic API', :type => :request do
  let(:name) { Faker::Lorem.words(4).join(' ') }

  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  let(:attributes) do
    {
      :name => name,
      :state => %i[public_access protected_access private_access].sample,
      :description => Faker::Lorem.words(20).join(' ')
    }
  end

  def request_body(attributes)
    {
      :data => {
        :type => 'topics',
        :attributes => attributes,
        :relationships => {
          :user => {
            :data => {
              :id => user.id,
              :type => 'users'
            }
          }
        }
      }
    }.to_json
  end

  def update_body(id, attributes)
    {
      :data => {
        :type => 'topics',
        :id => id,
        :attributes => attributes
      }
    }.to_json
  end

  describe 'GET /' do
    before do
      create_list :topic, 3

      add_accept_header
    end

    it 'returns successful' do
      get topics_path

      expect(response.status).to eq 200
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      json = JSON.parse response.body
      expect(json['data'].count).to eq 3
    end
  end

  describe 'POST /' do
    before do
      add_content_type_header
      add_auth_header
    end

    it 'rejects empty name' do
      post topics_path, :params => request_body(attributes.merge :name => ''), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'rejects no name' do
      post topics_path, :params => request_body(attributes.except :name), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'rejects empty state' do
      post topics_path, :params => request_body(attributes.merge :state => ''), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'rejects invalid state' do
      post topics_path, :params => request_body(attributes.merge :state => 'foo'), :headers => headers

      expect(response.status).to eq 422
      expect(jsonapi_error_code(response)).to eq [JSONAPI::VALIDATION_ERROR, JSONAPI::VALIDATION_ERROR]
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'returns successful' do
      post topics_path, :params => request_body(attributes), :headers => headers

      expect(response.status).to eq 201
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE

      json = JSON.parse response.body

      expect(json['data']['attributes']['name']).to eq attributes[:name]
    end
  end

  describe 'GET /:id' do
    context 'JSON' do
      before do
        add_accept_header
      end

      it 'rejects an invalid id' do
        get topic_path(:id => 0), :headers => headers

        expect(response.status).to eq 404
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
      end

      it 'returns successful' do
        get topic_path(:id => topic.id), :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
      end
    end

    context 'HTML' do
      before do
        (@headers ||= {})['Accept'] = 'text/html'
      end

      it 'rejects an invalid id' do
        get topic_path(:id => 0), :headers => headers

        expect(response.status).to eq 404
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
      end

      it 'returns successful' do
        get topic_path(:id => topic.id), :headers => headers

        expect(response.status).to eq 200
        expect(response.content_type).to eq 'text/html'
      end
    end
  end

  describe 'PUT/PATCH /:id' do
    context 'JSON' do
      before do
        add_content_type_header
        add_accept_header
        add_auth_header
      end

      it 'rejects id not equal to URL' do
        patch topic_path(:id => topic.id), :params => update_body(999, :name => 'foo'), :headers => headers

        expect(response.status).to eq 400
        expect(jsonapi_error_code(response)).to eq JSONAPI::KEY_NOT_INCLUDED_IN_URL
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
      end

      it 'rejects non-existant topics' do
        patch topic_path(:id => 999), :params => update_body(999, :name => 'foo'), :headers => headers

        expect(response.status).to eq 404
        expect(jsonapi_error_code(response)).to eq JSONAPI::RECORD_NOT_FOUND
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
      end

      it 'rejects empty name' do
        patch topic_path(:id => topic.id), :params => update_body(topic.id, :name => ''), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
      end

      it 'rejects invalid state' do
        patch topic_path(:id => topic.id), :params => update_body(topic.id, attributes.merge(:state => 'foo')), :headers => headers

        expect(response.status).to eq 422
        expect(jsonapi_error_code(response)).to eq JSONAPI::VALIDATION_ERROR
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
      end

      it 'updates name' do
        expect(topic.name).not_to eq name
        patch topic_path(:id => topic.id), :params => update_body(topic.id, :name => name), :headers => headers

        topic.reload
        expect(response.status).to eq 200
        expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
        expect(topic.name).to eq name
      end
    end

    context 'HTML' do
      before do
        add_auth_header
        @headers['Content-Type'] = 'text/html'
      end

      it 'updates html' do
        patch topic_path(:id => topic.id), :params => '<html></html>', :headers => headers

        expect(response.status).to eq 204
      end
    end
  end

  describe 'DELETE /:id' do
    before do
      add_auth_header
    end

    it 'rejects non-existant topics' do
      delete topic_path(:id => '0'), :headers => headers

      topic.reload
      expect(topic).not_to be_destroyed

      expect(response.status).to eq 404
      expect(response.content_type).to eq JSONAPI::MEDIA_TYPE
    end

    it 'deletes a topic' do
      id = topic.id
      delete topic_path(:id => topic.id), :headers => headers

      expect(-> { Topic.find id }).to raise_error ActiveRecord::RecordNotFound

      expect(response.status).to eq 204
    end
  end

  # TODO: user relationship
  # TODO: collaborators relationship
  # TODO: assets relationship
end
