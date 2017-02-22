require 'util/time_tracker'

class TimeTracking
  def self.load
    TimeTracker.track_class Image
    TimeTracker.track_class Transform
    TimeTracker.track_class Resampler
  end
  
  def self.end
    TimeTracker.print
  end
end
