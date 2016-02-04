require 'rails_helper'

RSpec.describe CreateUser, type: :service do
  describe '.build' do
    it 'inits, building CreatePluser' do
      expect(CreateUser::CreatePluser).to receive(:build)
      expect(CreateUser.build).to be_a(CreateUser)
    end
  end

  describe '#call' do
    let(:user){ FactoryGirl.build :user }
    let(:params){ {email: user.email, password: user.password, password_confirmation: user.password } }
    let(:create_pluser){ double }
    let(:success_result){ double(pluser_created?: true) }
    let(:error_message) { 'Error Message' }
    let(:failed_result){ double(pluser_created?: false, error_message: error_message) }
    subject { CreateUser.new(create_pluser).call(params) }

    it 'returns user' do
      allow(User).to receive(:new).and_return(user)
      allow(user).to receive(:valid?).and_return(false)
      allow(create_pluser).to receive(:call)
      allow(user).to receive(:save).and_return(true)

      expect(subject).to eq user
    end

    it 'validates' do
      expect(User).to receive(:new).with(params).and_return(user)
      expect(user).to receive(:valid?).and_return(true)
      allow(create_pluser).to receive(:call).and_return(success_result)
      allow(user).to receive(:save).and_return(true)
      subject
    end

    it 'calls CreatePluser' do
      allow(User).to receive(:new).and_return(user)
      allow(user).to receive(:valid?).and_return(true)
      expect(create_pluser).to receive(:call).with(user).and_return(success_result)
      allow(user).to receive(:save).and_return(true)
      subject
    end

    it 'saves' do
      allow(User).to receive(:new).and_return(user)
      allow(user).to receive(:valid?).and_return(true)
      allow(create_pluser).to receive(:call).and_return(success_result)
      expect(user).to receive(:save).and_return(true)
      subject
    end

    context 'invalid' do
      it 'does not call create_pluser' do
        allow(User).to receive(:new).and_return(user)
        allow(user).to receive(:valid?).and_return(false)
        expect(create_pluser).not_to receive(:call)
        allow(user).to receive(:save).and_return(true)
        subject
      end

      it 'does not save' do
        allow(User).to receive(:new).and_return(user)
        allow(user).to receive(:valid?).and_return(false)
        allow(create_pluser).to receive(:call).and_return(success_result)
        expect(user).not_to receive(:save)
        subject
      end      
    end

    context 'error on create_pluser' do
      it 'does not save' do
        allow(User).to receive(:new).and_return(user)
        allow(user).to receive(:valid?).and_return(true)
        allow(create_pluser).to receive(:call).and_return(failed_result)
        expect(user).not_to receive(:save)
        subject
      end

      it 'adds error message' do
        allow(User).to receive(:new).and_return(user)
        allow(user).to receive(:valid?).and_return(true)
        allow(create_pluser).to receive(:call).and_return(failed_result)
        expect(user).not_to receive(:save)
        expect(subject.errors[:base]).to eq [error_message]
      end 
    end
  end
end
