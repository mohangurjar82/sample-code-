require 'rails_helper'

RSpec.describe OrdersController, type: :controller do

  describe "GET #new" do
    context 'user signed in' do
      before do
        sign_in FactoryGirl.create(:user)
      end

      it 'is ok' do
        session[:product_ids] = [1,2,3]
        get :new
        expect(response).to be_ok
      end

      it 'redirects if cart is empty' do
        get :new
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
