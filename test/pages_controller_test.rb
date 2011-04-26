require 'test_helper'
require File.expand_path('../../app/controllers/blue_sparks/pages_controller', __FILE__)

class BlueSparks::PagesControllerTest < ActionController::TestCase

  def setup
    # @controller = BlueSparks::PagesController.new
    # @request = ActionController::TestRequest.new
    # @response = ActionController::TestResponse.new
  end

  context "on GET to /exists" do
    setup do
      get :show, :slug => "exists"
    end

    should respond_with(:success)
    should render_template('exists')
  end

  should "raise a routing error for an invalid page" do
    assert_raise ActionController::RoutingError do
      get :show, :slug => "invalid"
    end
  end

  should "raise missing template error for valid page with invalid partial" do
    assert_raise ActionView::MissingTemplate do
      get :show, :slug => "exists_but_references_nonexistent_partial"
    end
  end
end
