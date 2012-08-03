require 'spec_helper'

describe ProjectsController do
  let(:subscription) { create(:basic_subscription) }
  before { sign_in subscription.user }

  describe "#index" do
    before { get :index }
    it { should assign_to(:projects).with(subscription.projects) }
    it { should respond_with(:success) }
  end

  describe "#new" do
    before { get :new }
    it { should assign_to(:project).with(be_new_record) }
    it { should respond_with(:success) }
  end

  describe "#create" do
    it "creates a new project" do
      -> { post :create, project: {name: "My Project"} }.should change(Project, :count).by(1)
      response.should redirect_to projects_url
    end

    it "has errors" do
      -> { post :create, project: {name: ""} }.should_not change(Project, :count)

      flash[:alert].should be_present
      response.should render_template(:new)
    end
  end

  describe "#destroy" do
    it "deletes the project" do
      project = subscription.projects.create!(name: "For Deletion")

      -> { delete :destroy, id: project.to_param }.should change(Project, :count).by(-1)

      assigns[:project].should == project
      flash[:notice].should be_present
      response.should redirect_to projects_url
    end
  end
end