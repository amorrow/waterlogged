class AccomplishmentController < ApplicationController
  
  layout "main_layout"
  
  #for debugging - to find out exactly how this all works
  # def initialize
  #   RAILS_DEFAULT_LOGGER.error("********AccomplishmentController Init'd********")
  # end
  
  def index
    self.new
    render :action => 'new'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :controller => :waterlogged, :action => :index },
         :add_flash => { :warning => 'GET used when POST was expected' }

  # def list
  #     @accomplishment_pages, @accomplishments = paginate :accomplishments, :per_page => 10
  #   end

  def show
    @accomplishment = current_user.accomplishments.find(params[:id])
  end

  def new
    @accomplishment = Accomplishment.new
    @accomplishment.subject_id = params[:subject_id] if params[:subject_id]
    if md = /\/(\d{4})\/(\d{1,2})\/(\d{1,2})/.match(session[:last_index])
      @accomplishment.created_at = Time.gm(md[1], md[2], md[3])
    end
    #@subjects = Subject.find(:all)
  end

  def create
    @accomplishment = Accomplishment.new(params[:accomplishment])
    #@accomplishment.created_at = Time.now unless @accomplishment.created_at
    #begin
    #  Subject.find_with_uid(params[:accomplishment][:subject_id], current_user)
    #rescue
    if !current_user.subject_ids.include?(@accomplishment.subject_id)
      flash[:warning] = 'Invalid subject ID. Please quit screwing with the URLs.'
      redirect_to_home
      return
    end
    current_user.accomplishments << @accomplishment
    if @accomplishment.save
      flash[:notice] = 'Accomplishment was successfully created.'
      redirect_to_home
    else
    #   flash[:warning] = "Accomplishment couldn't be created!"
      render :action => 'new'
    end
  end

  def edit
    @accomplishment = current_user.accomplishments.find(params[:id])
    #@subjects = Subject.find(:all)
  end

  def update
    @accomplishment = current_user.accomplishments.find(params[:id])
    #something_crazy_to_crash_the_app
    #params[:accomplishment][:subject_id] = @accomplishment.subject_id unless params[:accomplishment][:subject_id]
    #raise Exception unless params[:accomplishment][:subject_id].to_i == 50
    unless current_user.subject_ids.include?(params[:accomplishment][:subject_id].to_i)
      flash[:warning] = "Invalid subject id!"
      render :action => 'edit'
      return
    end
    if @accomplishment.update_attributes(params[:accomplishment])
      flash[:notice] = 'Accomplishment was successfully updated.'
      redirect_to_home
    else
      render :action => 'edit'
    end
  end

  def destroy
    begin
      current_user.accomplishments.find(params[:id]).destroy
    rescue
      flash[:warning] = "Could not destroy accomplishment - please don't play with the URLs."
      redirect_to_home
      return
    end
    flash[:notice] = "Accomplishment destroyed."
    redirect_to_home
  end
end
