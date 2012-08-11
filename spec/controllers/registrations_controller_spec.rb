require 'spec_helper'

describe RegistrationsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }
  describe "#create" do
    context "sucessful signup" do
      before{ post :create, user: { email: "devise@example.com", password: "password", password_confirmation: "password" } }
      it { should set_the_flash[:analytics].to("/vp/create_account") }
    end
  end

  describe "#destroy" do
    context "sucessful signup" do
      before do
        sign_in(create(:trial_user))
        delete :destroy
      end

      it { should set_the_flash[:analytics].to("/vp/cancel_account") }
    end
  end
end