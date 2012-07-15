require 'spec_helper'

describe ProjectsController do
  include Devise::TestHelpers

  before do
    @customer = User.new(email: "test@example.com", password: "password", password_confirmation: "password")
    @customer.stripe_customer_token = "C12345"
    @customer.save!
    @subscription = @customer.build_subscription(plan_id: 1)
    @subscription.save!
    sign_in @customer
  end

  describe "#index" do
    before { get :index }
    it { should assign_to(:projects).with(@subscription.projects) }
    it { should respond_with(:success) }
  end

  describe "#new" do
    before { get :new }
    it { should assign_to(:project).with(be_new_record) }
    it { should respond_with(:success) }
  end

  describe "#create" do
    it "creates a new project" do
      lambda do
        post :create, project: {name: "My Project"}
      end.should change(Project, :count).by(1)
      response.should redirect_to projects_url
    end

    it "has errors" do
      lambda do
        post :create, project: {name: ""}
      end.should_not change(Project, :count)
      flash[:alert].should be_present
      response.should render_template(:new)
    end
  end

  describe "#destroy" do
    it "deletes the project" do
      @project = @subscription.projects.create!(name: "For Deletion")

      lambda do
        delete :destroy, id: @project.to_param
      end.should change(Project, :count).by(-1)

      assigns[:project].should == @project
      flash[:notice].should be_present
      response.should redirect_to projects_url
    end
  end
end