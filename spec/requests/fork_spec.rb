# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Fork API', :type => :request do
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

  ##
  # Request variables
  #
  ##
  # Tests
  #
  before { Topics::Create.call topic }

  describe 'POST /topics/:id/fork' do
    before { post topic_fork_path(:topic_id => id), :headers => headers(:access) }

    let(:id) { topic.id }

    it { is_expected.to have_http_status :created }

    describe 'creates a fork with upstream set to the topic' do
      subject { Topic.last }

      it { is_expected.to have_attributes :upstream => topic }
    end

    context 'when the identifier is invalid' do
      let(:id) { 0 }

      it { is_expected.to have_http_status :not_found }
      it { is_expected.to have_error.with_code JSONAPI::RECORD_NOT_FOUND }
    end

    context 'when the topic already has an upstream' do
      let(:topic) { create :topic, :upstream => create(:topic) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to have_error.with_code JSONAPI::VALIDATION_ERROR }
    end
  end
end
