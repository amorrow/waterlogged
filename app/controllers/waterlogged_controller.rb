class WaterloggedController < ApplicationController
  
  before_filter :login_required
  
  layout "main_layout"
  
  def index
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
    
    day_start = Time.local(params[:year].to_i, params[:month].to_i, params[:day].to_i, 0, 0, 0)
    day_end = Time.local(params[:year].to_i, params[:month].to_i, params[:day].to_i, 23, 59, 59)
    format_string = "%Y-%m-%d %H:%M:%S"
    
    @subjects.each do |s|
      @accomplishments << Accomplishment.find_all_by_subject_id(s,
      :conditions => ["created_at BETWEEN ? AND ?", day_start.strftime(format_string), day_end.strftime(format_string)])
    end
    
    render :action => 'index'
  end
end
