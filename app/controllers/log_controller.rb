class LogController < ApplicationController
  
  layout "main_layout"
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update, :add_subject, :remove_subject, :print_without_update ],
         :redirect_to => { :action => :list },
         :add_flash => { :warning => 'GET used when POST was expected' }

  def list
    @logs = current_user.waterlogs
  end

  def show
    @log = current_user.waterlogs.find(params[:id])
  end

  def new
    @log = Waterlog.new
    @formats = Format.find(:all)
  end

  def create
    @log = Waterlog.new(params[:log])
    current_user.waterlogs << @log
    @log.last_exported = Time.now
    if @log.save
      flash[:notice] = 'Log was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @log = current_user.waterlogs.find(params[:id])
    @formats = Format.find(:all)
  end

  def update
    @log = current_user.waterlogs.find(params[:id])
    if @log.update_attributes(params[:log])
      flash[:notice] = 'Log was successfully updated.'
      redirect_to :action => 'show', :id => @log
    else
      render :action => 'edit'
    end
  end

  def destroy
    begin
      @log = current_user.waterlogs.find(params[:id])
    rescue
      flash[:warning] = "Invalid id!"
      redirect_to :action => 'list'
      return
    end
    @log.subjects.clear
    @log.destroy
    current_user.reload
    redirect_to :action => 'list'
  end
  
  def add_subject
    #flash[:notice] = "Got it."
    begin
      @log = current_user.waterlogs.find(params[:id])
      @subject = current_user.subjects.find(params[:log][:subjects])
    rescue
      flash[:warning] = "Invalid ids. Please don't play with URLs."
      redirect_to :action => 'list'
      return
    end
    if @log.subjects.include?(@subject)
      flash[:notice]="That subject already belongs to this log."
      redirect_to :action => "show", :id => @log
      return
    end
    @log.subjects << @subject
    if @log.save
      flash[:notice] = "Added subject."
    end
    redirect_to :action => 'show', :id => @log
  end
  
  def remove_subject
    begin
      @log = current_user.waterlogs.find(params[:id])
      @subject = current_user.subjects.find(params[:subject_id])
    rescue
      flash[:warning] = "Don't play with URLs!"
      redirect_to :action => 'list'
      return
    end
    if !@log.subjects.include?(@subject)
      flash[:warning] = "Don't play with URLs!"
      redirect_to :action => 'show', :id => @log
      return
    end
    @log.subjects.delete(@subject)
    flash[:notice] = "Subject removed."
    redirect_to :action => 'show', :id => @log
  end
  
  def prep_data
    data = {}
    data[:user_name] = current_user.name
    data[:mentor_name] = current_user.mentor_name
    @log = current_user.waterlogs.find(params[:id])
    data[:subjects] = @log.subjects
    if params[:dates]
      start_date = Date.civil(params[:dates]["start(1i)"].to_i, params[:dates]["start(2i)"].to_i, params[:dates]["start(3i)"].to_i)
      end_date = Date.civil(params[:dates]["end(1i)"].to_i, params[:dates]["end(2i)"].to_i, params[:dates]["end(3i)"].to_i)
    end
    data[:end_date] = end_date ? end_date : Date.today
    data[:start_date] = start_date ? start_date : @log.last_exported.to_date + 1
    data[:weeks] = (Week.new(data[:start_date])..Week.new(data[:end_date])).to_a
    data[:weeks].each do |week|
      week.each_with_index do |day, i|
        week.a[i] = {}
        data[:subjects].each do |subject|
          week.a[i][subject.name] = begin
            subject.accomplishments.find(:all, :conditions => ["created_at BETWEEN ? AND ?", day.to_sql_string, day.to_sql_string_end_of_day])
          rescue ActiveRecord::RecordNotFound
            nil
          end
        end
      end
    end
    data
  end
  
  protected :prep_data
  
  def print_without_update
    d = prep_data
    # Permanent version
    render :inline => (current_user.waterlogs.find(params[:id]).format.body), :layout => "blank_layout", :locals => {:data => d}
    # Temp version (for testing only)
    # render :inline =>
    # (File.open(File.dirname(__FILE__)+'/../../default_formats/new.rhtml', "r") {|f| f.read}),
    # :layout => 'blank_layout', :locals => {:data => d}
  end
  
  def print_with_update
    l = current_user.waterlogs.find(params[:id])
    # this has to be done before the change or else it'll be goofy
    d = prep_data
    l.last_exported = Time.now
    unless l.save
      flash[:error] = "Couldn't update log. Please contact the sysadmin."
      redirect_to :action => 'show', :id => l
      return
    end
    render :inline => (l.format.body), :layout => "blank_layout", :locals => {:data => d}
  end
  
end
