# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  # commented out for rails 2.0.2
  # session :session_key => '_waterlogged_session_id'
  
  def login_required
      if session[:user_id]
        return true
      end
      flash[:warning]='Please login to continue'
      session[:return_to]=request.request_uri
      redirect_to :controller => '/user', :action => :login
      return false 
  end
  
  def admin_required
    if session[:user_id]
      if current_user.admin
        return true
      else
        flash[:warning] = "Sorry, you must be an admin to access the requested page."
        if request.env["HTTP_REFERER"] == url_for(:controller => :user, :action => :login)
          redirect_to_home
        else
          begin
            redirect_to :back
          rescue ::ActionController::RedirectBackError
            redirect_to_home
          end
        end
        return false
      end
    else
      flash[:warning] = "Please log in first"
      session[:return_to]=request.request_uri
      redirect_to :controller => :user, :action => login
      return false
    end
  end
  
  before_filter :login_required

  def current_user
    if @user
      @user
    else
      @user = User.find(session[:user_id])
    end
  end

  def redirect_to_stored
    if return_to = session[:return_to]
      session[:return_to]=nil
      redirect_to(return_to)
    else
      redirect_to :controller=>'waterlogged'
    end
  end
    
  def redirect_to_home
    if session[:last_index]
      redirect_to(session[:last_index])
    else
      redirect_to :controller => 'waterlogged', :action => 'index'
    end
  end
    
end
