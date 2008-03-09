class UserController < ApplicationController

  before_filter :login_required, :only=>['change_password', 'change_email', 'edit', 'delete', 'index']
  
  filter_parameter_logging :password, :password_confirmation

  layout "main_layout"

  def index
    render :action => 'index'
  end

  def signup
    @u = User.new(params[:user])
    if request.post?
      if User.count == 0
        # this is the first user - make him an admin my default
        @u.enabled = true
        @u.admin = true
        unless @u.save
          flash[:warning] = "Error creating your account."
          redirect_to :action=>:login
          return
        end
        flash[:notice] = "Signup successful. You're the first user and the only admin."
        session[:user_id] = @u.id
        redirect_to :controller => :waterlogged, :action => :index
        @u = nil
        return
      end
      @u.enabled = false
      @u.admin = false
      if @u.save
        @u = nil
        #notify admin here!
        redirect_to :action => :signup_success
      else
        flash[:warning] = "Error creating your account."
      end
    end
  end
  
  def signup_success
    #blank method
  end

  def login
    if request.post?
      if @user = User.authenticate(params[:user][:login], params[:user][:password])
        unless @user.enabled
          redirect_to :action => :signup_success
          return
        end
        session[:user_id] = @user.id
        flash[:notice] = "Login successful"
        # flash[:warning] = "MOTD: It's a new school year! Time to set up new subjects."
        # Add MOTD line there! May need a DB model just for it, we'll see. Probably throw it into
        # the admin db model.
        redirect_to_stored
      else
        flash[:warning] = "Login unsuccessful"
      end
    end
  end

  def logout
    session[:user_id] = nil
    @user = nil
    flash[:notice] = 'Logged out'
    redirect_to :action => 'login'
  end

  def forgot_password
    if request.post?
      u= User.find_by_email(params[:user][:email])
      if u and u.send_new_password
        flash[:notice]  = "A new password has been sent by email."
        redirect_to :action=>'login'
      else
        flash[:warning]  = "Couldn't send password"
      end
    end
  end

  def change_password
    if request.post?
      current_user.update_attributes(:password=>params[:user][:password], :password_confirmation => params[:user][:password_confirmation])
      if current_user.save
        flash[:notice]="Password Changed"
        redirect_to :action => 'index'
      end
    end
  end
  
  def edit
    @user = current_user
    if request.post?
      #change the datum here
      if current_user.update_attributes_without_validating_password(:name=>params[:user][:name],:mentor_name=>params[:user][:mentor_name],:email=>params[:user][:email])
        flash[:notice] = "Info updated"
        redirect_to :action => 'index'
      else
        current_user.reload
      end
    end
  end
  
  def delete
    if request.post?
      current_user.subjects.clear
      current_user.accomplishments.clear
      current_user.logs.clear
      current_user.destroy
      session[:user_id] = nil
      @user = nil
      flash[:notice] = "Account successfully destroyed."
      redirect_to :action => 'login'
    end
  end

end