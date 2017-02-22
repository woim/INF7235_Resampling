class TimeTracker
  @@times = Hash.new

  def self.track_method(classRef, method)
    puts "#{classRef}::#{method}::Tracking enabled"
    classRef.send(:alias_method, "#{method}_without_notification", method)
    classRef.send(:define_method, method) do |*args, &block|
      start = Time.now
      returnValue = self.send( "#{method}_without_notification", *args, &block)
      finish = Time.now
      TimeTracker.addTime("#{classRef}::#{method}", finish-start)
      returnValue
    end
  end

  def self.track_class(classRef)
    classRef.send(:instance_methods, false).each {|method| self.track_method( classRef, method.to_s )}
  end

  def self.addTime(key, time)
    @@times[key]= 0 if @@times[key].nil?
    @@times[key] += time
  end


  def self.print
    @@times.sort_by { | name , time| time }
      .each { | name, time | puts "#{name} #{time}" }
  end
end
