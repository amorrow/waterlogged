class SubjectController < ApplicationController
  
  layout "main_layout"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :add_to_log ],
         :redirect_to => { :action => :list },
         :add_flash => {:warning => 'GET used when POST was expected' }

  def list
    @subjects = current_user.subjects
  end

  def show
    @subject = current_user.subjects.find(params[:id])
  end

  def new
    @subject = Subject.new
  end

  def create
    @subject = Subject.new(params[:subject])
    @subject.user_id = current_user.id
    if @subject.save
      flash[:notice] = 'Subject was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @subject = current_user.subjects.find(params[:id])
  end

  def update
    @subject = current_user.subjects.find(params[:id])
    if @subject.update_attributes(params[:subject])
      flash[:notice] = 'Subject was successfully updated.'
      if @subject.archived
        redirect_to :action => 'remove_links', :id => @subject
      else
        redirect_to :action => 'show', :id => @subject
      end
    else
      render :action => 'edit'
    end
  end
  
  def remove_links
    if request.post?
      @subject = current_user.subjects.find(params[:id])
      @subject.logs.clear
      flash[:notice] = "Subject successfully removed from all logs."
      redirect_to :action => 'show', :id => @subject
    else
      @subject = current_user.subjects.find(params[:id])
    end
  end

  def destroy
    begin
      @subject = current_user.subjects.find(params[:id])
    rescue
      flash[:warning] = "Invalid subject ID. Don't play with URLs - it's bad for your health."
      redirect_to :action => 'list'
      return
    end
    @subject.accomplishments.clear
    @subject.logs.clear
    @subject.destroy
    current_user.reload
    redirect_to :action => 'list'
  end
  
  def add_to_log
    #flash[:notice] = "Got it."
    begin
      @subject = current_user.subjects.find(params[:id])
      #RAILS_DEFAULT_LOGGER.error("Got the subject!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
      @log = current_user.logs.find(params[:subject][:logs])
    rescue
      flash[:warning] = "Invalid ids! Quit screwing around!"
      redirect_to :action => 'list'
      return
    end
    if @subject.logs.include?(@log)
      flash[:notice]="This subject already belongs to that log."
      redirect_to :action => "show", :id => @subject
      return
    end
    @subject.logs << @log
    if @subject.save
      flash[:notice] = "Added to log."
    end
    redirect_to :action => 'show', :id => @subject
  end
  
  def remove_from_log
    begin
      @subject = current_user.subjects.find(params[:id])
      @log = current_user.logs.find(params[:log_id])
    rescue
      flash[:warning] = "Don't play with URLs! It makes baby Jesus cry!"
      redirect_to :action => 'list'
      return
    end
    unless @subject.logs.include?(@log)
      flash[:warning] = "Don't play with URLs! It makes baby Jesus cry!"
      redirect_to :action => 'show', :id => @subject
      return
    end
    @subject.logs.delete(@log)
    flash[:notice] = "Subject removed from log."
    redirect_to :action => 'show', :id => @subject
  end
  
end
