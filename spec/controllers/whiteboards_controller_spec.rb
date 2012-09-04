require 'spec_helper'

describe WhiteboardsController do
  let(:subscription) { create(:basic_subscription) }
  let(:whiteboard) { create(:drawing, subscription: subscription) }

  before { sign_in subscription.user }

  describe "#index" do
    before { get :index }
    it { should assign_to(:subscription).with(subscription) }
    it { should assign_to(:whiteboards).with(subscription.drawings) }
    it { should respond_with(:success) }
  end

  describe "#create" do
    before { post :create }
    it { should assign_to(:subscription).with(subscription) }

    it "creates a whiteboard" do
      -> { post :create }.should change(Drawing, :count).by(1)
    end

    it "redirects to show" do
      whiteboard = assigns[:whiteboard]
      whiteboard.should be_present
      response.should redirect_to whiteboard_path(whiteboard)
    end
  end

  describe "#update" do
    before { put :update, id: whiteboard.to_param, format: :js }
    it { should assign_to(:subscription).with(subscription) }
    it { should assign_to(:whiteboard).with(whiteboard) }
    it { should respond_with(:success) }
  end

  describe "#show" do
    before { get :show, id: whiteboard.to_param }
    it { should assign_to(:subscription).with(whiteboard.subscription) }
    it { should assign_to(:whiteboard).with(whiteboard) }
    it { should respond_with(:success) }
  end
end