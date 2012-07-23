require 'spec_helper'

describe ProjectImagesController do
  include Devise::TestHelpers

  before do
    @customer = User.new(email: "test@example.com", password: "password", password_confirmation: "password")
    @customer.stripe_customer_token = "C12345"
    @customer.save!
    @subscription = @customer.build_subscription(plan_id: 1)
    @subscription.save!
    sign_in @customer

    @project = @subscription.projects.create!(name: "For Deletion")
  end

  describe "#new" do
    before { get :new, project_id: @project.to_param }
    it { should assign_to(:project_image).with(be_new_record) }
    it { should respond_with(:success) }
  end

  describe "#create" do
    it "creates a new project_image" do
      file = fixture_file_upload('/files/rails.png')
      lambda do
        post :create, project_id: @project.to_param, project_image: {canvas: file }
      end.should change(ProjectImage, :count).by(1)
      response.should redirect_to projects_url
    end

    it "has errors" do
      lambda do
        post :create, project_id: @project.to_param, project_image: { }
      end.should_not change(ProjectImage, :count)
      flash[:alert].should be_present
      response.should render_template(:new)
    end
  end
end