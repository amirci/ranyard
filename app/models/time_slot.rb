class TimeSlot
  attr_accessor :start, :finish, :id

  def initialize(attributes = {})
    @start = attributes[:start]
    @finish = attributes[:finish]
  end
  
  def to_s
    "{Starts: #{@start.strftime('%Y-%m-%d %H:%M')}, Finishes: #{@finish.strftime('%Y-%m-%d %H:%M')}}"
  end
  
  def ==(other)
    eql?(other)
  end

  def <=>(other)
    s = self.start <=> other.start
    f = self.finish <=> other.finish
    if s + f == 0
      0
    elsif s < 0 || (s == 0 && f > 0)
      -1
    else
      1
    end
  end
  
  def eql?(other)
    !other.nil? && other.to_s.eql?(self.to_s)
  end
  
  def hash
    @start.hash ^ @finish.hash
  end
  
  def self.parse(slot, separator = '-')
    times = slot.split(separator).map { |s| DateTime.parse(s) }
    TimeSlot.new(start: times[0], finish: times[1])
  end
  
end