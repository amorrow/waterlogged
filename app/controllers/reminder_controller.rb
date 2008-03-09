class ReminderController < ApplicationController
  
  layout "main_layout"
  
  def index
    list
    render :action => 'list'
  end
  
  def list
    @reminders = (current_user.log_reminders) + ([]) #put current_user.user_reminders in those parens
  end
  
  def show
    unless @reminder = get_reminder
      flash[:warning] = "No such reminder!"
      redirect_to :action => 'list'
    end
  end
  
  def edit
    unless @reminder = get_reminder
      flash[:warning] = "No such reminder!"
      redirect_to :action => 'list'
    end
  end
  
  private
  
  def get_reminder
    begin
      current_user.log_reminders.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      begin
        current_user.user_reminders.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
  
end
