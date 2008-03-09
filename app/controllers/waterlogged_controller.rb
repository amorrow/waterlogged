class WaterloggedController < ApplicationController
  
  #before_filter :login_required
  
  layout "main_layout"
  
  def index
    # if params[:year].to_i==Time.now.year and params[:month].to_i==Time.now.month and params[:day].to_i==Time.now.day
    #   redirect_to :action => 'index'
    #   return
    # end
    session[:last_index] = request.request_uri
    @subjects = current_user.subjects.reject {|sub| sub.archived}
    @accomplishments = []
    if !params[:year]
      session[:last_index] = nil
      params[:year] = Time.now.year
      params[:month] = Time.now.month
      params[:day] = Time.now.day
    end
    @page_date = Date.civil(params[:year].to_i, params[:month].to_i, params[:day].to_i)
    @page_date_y = @page_date - 1
    @page_date_t = @page_date + 1
    fstr = "#{params[:year]}-#{params[:month]}-#{params[:day]}"
    @subjects.each do |s|
      @accomplishments << Accomplishment.find_all_by_subject_id(s,
      :conditions => ["created_at BETWEEN ? AND ?", "#{fstr} 00:00:00", "#{fstr} 23:59:59"])
      #i'll find a better way to do all of that soon. it works well enough for now.
    end
    render :action => 'index'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  #dunno whether or not to remove this - i'll check into it later
  #verify :method => :post, :only => [ :destroy, :create, :update ],
  #       :redirect_to => { :action => :list }

  # def list
  #     @subject_pages, @subjects = paginate :subjects, :per_page => 10, :conditions => ["user_id = ?", current_user]
  #   end
  # 
  #   def show
  #     @subject = Subject.find_with_uid(params[:id], current_user)
  #   end
  # 
  #   def new
  #     @subject = Subject.new
  #   end
  # 
  #   def create
  #     @subject = Subject.new(params[:subject])
  #     @subject.user_id = current_user.id
  #     if @subject.save
  #       flash[:notice] = 'Subject was successfully created.'
  #       redirect_to :action => 'list'
  #     else
  #       render :action => 'new'
  #     end
  #   end
  # 
  #   def edit
  #     @subject = Subject.find_with_uid(params[:id], current_user)
  #   end
  # 
  #   def update
  #     @subject = Subject.find_with_uid(params[:id], current_user)
  #     if @subject.update_attributes(params[:subject])
  #       flash[:notice] = 'Subject was successfully updated.'
  #       redirect_to :action => 'show', :id => @subject
  #     else
  #       render :action => 'edit'
  #     end
  #   end
  # 
  #   def destroy
  #     Subject.find_with_uid(params[:id], current_user).destroy
  #     redirect_to :action => 'list'
  #   end
end
