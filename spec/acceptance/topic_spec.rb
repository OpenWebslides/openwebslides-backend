# frozen_string_literal: true

require 'rails_helper'

##
# Topic acceptance test
#
RSpec.describe 'Topic', :type => :request do
  ##
  # Configuration
  #
  before :each do
    OpenWebslides.configure do |config|
      ##
      # Absolute path to persistent repository storage
      #
      config.repository.path = Dir.mktmpdir
    end
  end

  ##
  # Test variables
  #
  let(:user) { create :user, :confirmed }

  let(:title) { Faker::Lorem.words(4).join(' ') }
  let(:description) { Faker::Lorem.words(20).join(' ') }

  let(:content) do
    root = {
      'id' => 'qyrgv0bcd6',
      'type' => 'contentItemTypes/ROOT',
      'childItemIds' => ['ivks4jgtxr']
    }
    heading = {
      'id' => 'ivks4jgtxr',
      'type' => 'contentItemTypes/HEADING',
      'text' => 'This is a heading',
      'metadata' => { 'tags' => [], 'visibilityOverrides' => {} },
      'subItemIds' => ['oswmjc09be']
    }
    paragraph = {
      'id' => 'oswmjc09be',
      'type' => 'contentItemTypes/PARAGRAPH',
      'text' => 'This is a paragraph',
      'metadata' => { 'tags' => [], 'visibilityOverrides' => {} },
      'subItemIds' => []
    }

    [root, heading, paragraph]
  end

  ##
  # Tests
  #
  describe 'A user can create a topic' do
    it 'returns without any errors' do
      params = {
        :data => {
          :type => 'topics',
          :attributes => {
            :title => title,
            :description => description,
            :state => 'private_access'
          },
          :relationships => {
            :user => {
              :data => {
                :type => 'users',
                :id => user.id
              }
            }
          }
        }
      }

      headers = {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => 'application/vnd.api+json, application/vnd.openwebslides+json; version=3.0.0',
        'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
      }

      post '/api/topics', :params => params.to_json, :headers => headers

      expect(response.status).to eq 201
      data = JSON.parse(response.body)['data']
      expect(data['attributes']).to match 'title' => title,
                                          'description' => description,
                                          'state' => 'private_access'
    end
  end

  describe 'A user can retrieve the contents of a topic' do
    let(:topic) { create :topic }

    before :each do
      service = TopicService.new topic

      # Make sure the topic repository is created
      service.create

      # Populate the topic with some dummy content
      service.update :author => user,
                     :content => content
    end

    it 'returns without any errors' do
      headers = {
        'Accept' => 'application/vnd.api+json, application/vnd.openwebslides+json; version=3.0.0'
      }

      get "/api/topics/#{topic.id}/content", :headers => headers

      expect(response.status).to eq 200
      data = JSON.parse(response.body)['data']['attributes']
      expect(data['content']).to match_array content
    end
  end

  describe 'An owner can update the contents of a topic' do
    let(:topic) { create :topic, :user => user }

    before(:each) do
      service = TopicService.new topic

      # Make sure the topic repository is created
      service.create
    end

    it 'returns without any errors' do
      params = {
        :data => {
          :id => topic.id,
          :type => 'contents',
          :attributes => {
            :content => content
          }
        }
      }

      headers = {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => 'application/vnd.api+json, application/vnd.openwebslides+json; version=3.0.0',
        'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
      }

      patch "/api/topics/#{topic.id}/content", :params => params.to_json, :headers => headers

      expect(response.status).to eq 204

      get "/api/topics/#{topic.id}/content", :headers => headers

      expect(response.status).to eq 200
      data = JSON.parse(response.body)['data']['attributes']
      expect(data['content']).to match_array content
    end
  end

  describe 'An owner can delete a topic' do
    let(:topic) { create :topic, :user => user }

    before(:each) do
      service = TopicService.new topic

      # Make sure the topic repository is created
      service.create
    end

    it 'returns without any errors' do
      headers = {
        'Content-Type' => 'application/vnd.api+json',
        'Accept' => 'application/vnd.api+json, application/vnd.openwebslides+json; version=3.0.0',
        'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
      }

      delete "/api/topics/#{topic.id}", :headers => headers

      expect(response.status).to eq 204

      get "/api/topics/#{topic.id}", :headers => headers

      expect(response.status).to eq 404
    end
  end
end
