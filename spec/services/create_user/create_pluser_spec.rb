require 'rails_helper'

RSpec.describe CreateUser::CreatePluser, type: :service do
  describe '.build' do
    it 'inits, using ThePlatform::Data' do
      expect(CreateUser::CreatePluser).to receive(:new).with(ThePlatform::Data).and_call_original
      expect(CreateUser::CreatePluser.build).to be_a(CreateUser::CreatePluser)
    end
  end

  describe '#call' do
    let(:tpdata) { double }
    let(:user) { FactoryGirl.build :user }
    subject { CreateUser::CreatePluser.new(tpdata).call(user) }

    it 'creates pluser'
    
    it 'returns result' do
      expect(subject).to be_pluser_created
    end
  end
end
