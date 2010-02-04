require File.dirname(__FILE__) + '/../test_helper'
require 'log_controller'

# Re-raise errors caught by the controller.
class LogController; def rescue_action(e) raise e end; end

class LogControllerTest < Test::Unit::TestCase
  fixtures :logs

  def setup
    @controller = LogController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @first_id = logs(:first).id
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

    assert_not_nil assigns(:logs)
  end

  def test_show
    get :show, :id => @first_id

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:log)
    assert assigns(:log).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:log)
  end

  def test_create
    num_logs = Waterlog.count

    post :create, :log => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_logs + 1, Waterlog.count
  end

  def test_edit
    get :edit, :id => @first_id

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:log)
    assert assigns(:log).valid?
  end

  def test_update
    post :update, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => @first_id
  end

  def test_destroy
    assert_nothing_raised {
      Waterlog.find(@first_id)
    }

    post :destroy, :id => @first_id
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      Waterlog.find(@first_id)
    }
  end
end
