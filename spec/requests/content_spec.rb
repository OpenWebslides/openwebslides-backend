# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Content API', :type => :request do
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
  let(:user) { create :user, :confirmed }
  let(:topic) { create :topic, :user => user }

  let(:content) { random_content 10, topic.root_content_item_id }

  ##
  # Request variables
  #
  def update_body(message)
    {
      :data => {
        :type => 'contents',
        :attributes => {
          :message => message,
          :content => [{
            :id => topic.root_content_item_id,
            :type => 'contentItemTypes/ROOT'
          }]
        }
      }
    }.to_json
  end

  ##
  # Tests
  #
  before { Topics::Create.call topic }

  describe 'GET /' do
    before { get topic_content_path(:topic_id => topic.id), :headers => headers }

    it { is_expected.to have_http_status :ok }
    it { is_expected.to have_attribute(:content).with_value [] }

    context 'when the topic already has some content' do
      prepend_before { Topics::UpdateContent.call topic, content, user, 'Update content' }

      it { is_expected.to have_http_status :ok }
      it { is_expected.to have_attribute(:content).with_value [] }
    end
  end

  describe 'PUT/PATCH /' do
    before { patch topic_content_path(:topic_id => topic.id), :params => update_body(message), :headers => headers(:access) }

    let(:message) { Faker::Lorem.words(4).join ' ' }

    it { is_expected.to have_http_status :no_content }

    # FIXME: reenable this test when async error handling is fixed
    # context 'when the message is empty' do
    #   let(:message) { '' }
    #
    #   it { is_expected.to have_http_status :unprocessable_entity }
    #   it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    # end
  end
end
