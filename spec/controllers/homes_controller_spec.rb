require 'spec_helper'

describe HomesController do
  describe "#index" do
    before { get :index }
    it { should respond_with(:success) }
  end
end