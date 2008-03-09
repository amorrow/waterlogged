require File.dirname(__FILE__) + '/../test_helper'
require 'accomplishment_controller'

# Re-raise errors caught by the controller.
class AccomplishmentController; def rescue_action(e) raise e end; end

class AccomplishmentControllerTest < Test::Unit::TestCase
  fixtures :accomplishments

  def setup
    @controller = AccomplishmentController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = accomplishments(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:accomplishments)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:accomplishment)
    assert assigns(:accomplishment).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:accomplishment)
  end

  def test_create
    num_accomplishments = Accomplishment.count

    post :create, :accomplishment => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_accomplishments + 1, Accomplishment.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:accomplishment)
    assert assigns(:accomplishment).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Accomplishment.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Accomplishment.find(@first_id)
    }
  end
end
