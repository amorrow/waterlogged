class AdminController < ApplicationController
  
  before_filter :admin_required
  layout 'main_layout'
  
  def index
    redirect_to :action => 'list'
  end
  
  def list
    @users = User.find(:all)
  end
  
  def hide_users
    unless (params[:show_hidden] == "yes")
      render(:partial => "user_list", :object => User.find_all_by_enabled(false))
    else
      render(:partial => 'user_list', :object => User.find(:all))
    end
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def enable
    if request.post?
      # enable the user & notify the user
      user = User.find(params[:id])
      user.update_attributes_without_validating_password(:enabled => true)
      #p params[:show_hidden]
      if (params[:show_hidden] == "yes")
        render(:partial => 'user_list', :object => User.find(:all))
      else
        render(:partial => "user_list", :object => User.find_all_by_enabled(false))
      end
    else
      redirect_to :action => :list
    end
  end
  
  def disable
    @user = User.find(params[:id])
    if request.post?
      @user.update_attributes_without_validating_password(:enabled => false)
    end
    redirect_to :action => :show, :id => @user
  end
end
