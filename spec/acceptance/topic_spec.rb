# frozen_string_literal: true

require 'rails_helper'

##
# Topic acceptance test
#
RSpec.describe 'Topic', :type => :request do
  ##
  # Configuration
  #
  before do
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
      'id' => topic.root_content_item_id,
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
  context 'A user' do
    describe 'can create a topic' do
      it 'returns without any errors' do
        params = {
          :data => {
            :type => 'topics',
            :attributes => {
              :title => title,
              :description => description,
              :access => 'private',
              :rootContentItemId => 'ivks4jgtxr'
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
          'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
          'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
        }

        post '/api/topics', :params => params.to_json, :headers => headers

        expect(response.status).to eq 201
        data = JSON.parse(response.body)['data']
        expect(data['attributes']).to match 'title' => title,
                                            'description' => description,
                                            'access' => 'private',
                                            'rootContentItemId' => 'ivks4jgtxr'
      end
    end

    context 'An owner' do
      describe 'can delete a topic' do
        let(:topic) { create :topic, :user => user }

        before do
          # Make sure the topic repository is created
          Topics::Create.call topic
        end

        it 'returns without any errors' do
          headers = {
            'Content-Type' => 'application/vnd.api+json',
            'Accept' => "application/vnd.api+json, application/vnd.openwebslides+json; version=#{OpenWebslides.config.api.version}",
            'Authorization' => "Bearer #{JWT::Auth::Token.from_user(user).to_jwt}"
          }

          delete "/api/topics/#{topic.id}", :headers => headers

          expect(response.status).to eq 204

          get "/api/topics/#{topic.id}", :headers => headers

          expect(response.status).to eq 404
        end
      end
    end
  end
end
