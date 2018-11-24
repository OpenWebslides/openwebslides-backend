# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AssetPolicy do
  subject { described_class.new user, asset }

  let(:asset) { topic.assets.first }

  context 'for public topics' do
    let(:topic) { build :topic, :with_assets, :with_collaborators, :access => :public }

    context 'for a guest' do
      let(:user) { nil }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'for a user' do
      let(:user) { build :user }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'for a user' do
      let(:user) { topic.user }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'for protected topics' do
    let(:topic) { build :topic, :with_assets, :with_collaborators, :access => :protected }

    context 'for a guest' do
      let(:user) { nil }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to forbid_action :show_topic }
    end

    context 'for a user' do
      let(:user) { build :user }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to forbid_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'for a user' do
      let(:user) { topic.user }

      it 'should not permit :create for another user' do
        expect(described_class.new(build(:user), asset)).to forbid_action :create
      end

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end
  end

  context 'for private topics' do
    let(:topic) { build :topic, :with_assets, :with_collaborators, :access => :private }

    context 'for a guest' do
      let(:user) { nil }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to forbid_action :show_topic }
    end

    context 'for a user' do
      let(:user) { build :user }

      it { is_expected.to forbid_action :create }
      it { is_expected.to forbid_action :show }
      it { is_expected.to forbid_action :update }
      it { is_expected.to forbid_action :destroy }

      it { is_expected.to forbid_action :show_topic }
    end

    context 'for a collaborator' do
      let(:user) { topic.collaborators.first }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end

    context 'for a user' do
      let(:user) { topic.user }

      it { is_expected.to permit_action :create }
      it { is_expected.to permit_action :show }
      it { is_expected.to permit_action :update }
      it { is_expected.to permit_action :destroy }

      it { is_expected.to permit_action :show_topic }
    end
  end
end
