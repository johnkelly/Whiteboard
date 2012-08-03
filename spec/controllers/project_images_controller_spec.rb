require 'spec_helper'

describe ProjectImagesController do
  let(:project) { create(:project) }
  let!(:subscription) { create(:basic_subscription) }

  before do
    sign_in subscription.user
  end

  describe "#new" do
    before { get :new, project_id: project.to_param }
    it { should assign_to(:project_image).with(be_new_record) }
    it { should respond_with(:success) }
  end

  describe "#create" do
    it "creates a new project_image" do
      file = fixture_file_upload('/files/rails.png')
      -> { post :create, project_id: project.to_param, project_image: {canvas: file } }.should change(ProjectImage, :count).by(1)
      response.should redirect_to projects_url
    end

    it "has errors" do
      -> { post :create, project_id: project.to_param, project_image: { } }.should_not change(ProjectImage, :count)
      flash[:alert].should be_present
      response.should render_template(:new)
    end
  end
end