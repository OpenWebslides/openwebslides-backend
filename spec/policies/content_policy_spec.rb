# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ContentPolicy do
  subject { described_class.new user, content }

  let(:content) { build :content, :topic => topic }
  let(:topic) { build :topic, :state => :public_access, :user => user }

  context 'for a guest' do
    let(:user) { nil }

    context 'for public topics' do
      let(:topic) { build :topic, :state => :public_access }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end

    context 'for protected topics' do
      let(:topic) { build :topic, :state => :protected_access }
      it 'does not permit anything' do
        expect(subject).to forbid_action :show

        expect(subject).to forbid_action :show_topic
      end
    end

    context 'for private topics' do
      let(:topic) { build :topic, :state => :private_access }
      it 'does not permit anything' do
        expect(subject).to forbid_action :show

        expect(subject).to forbid_action :show_topic
      end
    end
  end

  context 'for a user' do
    let(:user) { build :user }

    context 'for public topics' do
      let(:topic) { build :topic, :state => :public_access }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end

    context 'for protected topics' do
      let(:topic) { build :topic, :state => :protected_access }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end

    context 'for private topics' do
      let(:topic) { build :topic, :state => :private_access }
      it 'does not permit anything' do
        expect(subject).to forbid_action :show

        expect(subject).to forbid_action :show_topic
      end
    end
  end

  context 'for a collaborator' do
    let(:user) { build :user, :with_topics }

    context 'for public topics' do
      let(:topic) { build :topic, :with_collaborators, :state => :public_access }
      let(:user) { topic.collaborators.first }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end

    context 'for protected topics' do
      let(:topic) { build :topic, :with_collaborators, :state => :protected_access }
      let(:user) { topic.collaborators.first }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end

    context 'for private topics' do
      let(:topic) { build :topic, :with_collaborators, :state => :private_access }
      let(:user) { topic.collaborators.first }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end
  end

  context 'for a user' do
    let(:user) { build :user, :with_topics }

    context 'for public topics' do
      let(:topic) { build :topic, :state => :public_access }
      let(:user) { topic.user }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end

    context 'for protected topics' do
      let(:topic) { build :topic, :state => :protected_access }
      let(:user) { topic.user }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end

    context 'for private topics' do
      let(:topic) { build :topic, :state => :private_access }
      let(:user) { topic.user }
      it 'permits only show' do
        expect(subject).to permit_action :show

        expect(subject).to permit_action :show_topic
      end
    end
  end
end
