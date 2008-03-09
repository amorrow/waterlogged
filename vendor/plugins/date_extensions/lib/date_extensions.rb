# DateExtensions - modifications to the Date class and an extra class, Week.
#require 'date'
# I just added a few class methods and methods to convert them into strings readable
# by an SQL server.
class Date
  
  def self.yesterday
    Date.today - 1
  end
  
  def self.tomorrow
    Date.today + 1
  end
  
  def to_sql_string
    "#{self.year}-#{self.month}-#{self.day} 00:00:00"
  end
  
  def to_sql_string_end_of_day
    "#{self.year}-#{self.month}-#{self.day} 23:59:59"
  end
  
  def prev
    self - 1
  end
  
end

# This class represents a week. Developed for use in WaterLogged.
class Week
  
  include Comparable
  
  attr_reader :days
  attr_reader :attachments
  
  alias a attachments
  
  # Pass a Date, DateTime, or Time object and the week will represent the corresponding week.
  # Notice that the Week class itself _always_ uses Date objects.
  def initialize(d=Date.today)
    if d.instance_of? Time
      rd = Date.civil(d.year, d.month, d.day)
    elsif d.instance_of? DateTime
      rd = Date.jd(d.jd)
    else
      rd = d.dup # always make a duplicate before modifying arguments
    end
    raise ArgumentError, "Must pass Date, DateTime, or Time object" unless rd.instance_of? Date
    @attachments = []
    @days = []
    rd -= 1 while rd.wday > 0
    # puts "Got past first while"
    # puts rd
    @days << rd
    for i in (1...7)
      @days[i] = (rd + i)
    end
    # puts "Got past for"
    @days.freeze
  end
  
  def Week.this
    Week.new
  end
  
  def Week.next
    Week.new.next
  end
  
  def Week.last
    Week.new.last
  end
  
  # Comparisons are made based on the first day of the week.
  def <=>(other)
    @days[0] <=> other.days[0]
  end
  
  # If the given day falls within this week, true. Otherwise, false.
  # If the given weeks are equal, true.
  def ===(other)
    case other
    when Date
      @days.include? Date.jd(other.jd) #in case it's a DateTime
    when Time
      @days.include? Date.civil(other.year, other.month, other.day)
    else
      super
    end
  end  
  # Important! The number of days you give is added to the LAST day of the week. The week
  # in which the resulting date falls is returned.
  def +(num)
    # raise ArgumentError, "Must pass Integer or Float" unless rnum = num.to_i
    Week.new(@days[6] + num.to_i)
  end
  
  # Important! The number of days you give is subtracted from the FIRST day of the week. The week
  # in which the resulting date falls is returned.
  def -(num)
    # raise ArgumentError, "Must pass Integer or Float" unless rnum = num.to_i
    Week.new(@days[0] - num.to_i)
  end
  
  def succ
    Week.new(@days[6] + 1)
  end
  
  alias next succ
  
  def prev
    Week.new(@days[0] - 1)
  end
  
  alias last prev
  
  def to_s
    @days[0].to_s + " -- " + @days[6].to_s
  end
  
  %w{ sun mon tue wed thu fri sat }.each_with_index do |name, i|
    eval <<-END
    def #{name}
      @days[#{i.to_s}]
    end
    END
  end
  
  # Allows forwarding of messages to the days array, letting you leave off the .days call
  def method_missing(symbol, *args, &block)
    if @days.methods.include? symbol.to_s
      @days.send(symbol, *args, &block)
    else
      super
    end
  end
  
end