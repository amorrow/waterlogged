require File.dirname(__FILE__) + '/../test_helper'
require 'subject_controller'

# Re-raise errors caught by the controller.
class SubjectController; def rescue_action(e) raise e end; end

class SubjectControllerTest < Test::Unit::TestCase
  def setup
    @controller = SubjectController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
