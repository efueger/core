module Bucky
  class Schedule

    def initialize(*args)
      if args.blank?
        @schedule = IceCube::Schedule.new(Time.current.utc)
      elsif args.first.is_a?(IceCube::Schedule)
        schedule = args.first
        # Convert to UTC
        schedule.start_time = schedule.start_time.utc unless schedule.start_time.blank?
        schedule.end_time = schedule.end_time.utc unless schedule.end_time.blank?

        @schedule = IceCube::Schedule.from_hash(schedule.to_hash)
      else
        start_time = args.first.utc
        options = args.second || {}
        if options[:end_time].present?
          options[:end_time] = options[:end_time].utc
        end
        @schedule = IceCube::Schedule.new(start_time, options)
      end
    end

    def time_zone=(tz = Time.zone)
      @time_zone = tz.clone
    end

    def time_zone
      @time_zone || Time.zone
    end

    def to_hash
      if @schedule.present?
        hash = @schedule.to_hash
        hash[:start_time] = hash.delete(:start_date)
        hash
      else
        {}
      end
    end

    def frequency
      @schedule.frequency
    end

    def frequency=(frequency)
      @schedule.frequency = frequency
    end

    def end_time
      @schedule.end_time.in_time_zone(time_zone)
    end

    def end_time=(end_time)
      @schedule.end_time = end_time.utc
    end

    def occurs_on?(date)
      # Not sure about converting to UTC here or not
      @schedule.occurs_on?(date)
    end

    def occurring_at?(time)
      @schedule.occurring_at?(time.utc)
    end

    def next_occurrence(from = Time.current)
      @schedule.next_occurrence(from.utc)
    end

    def next_occurrences(num, from = Time.current)
      @schedule.next_occurrences(num, from.utc)
    end

    def add_recurrence_time(time)
      @schedule.add_recurrence_time(time.utc)
    end

    def remove_recurrence_time(time)
      @schedule.remove_recurrence_time(time.utc)
    end

    def recurrence_times
      @schedule.recurrence_times.collect do |recurrence_time|
        if recurrence_time.respond_to?(:in_time_zone)
          recurrence_time.in_time_zone(time_zone)
        elsif recurrence_time.respond_to?(:to_time)
          recurrence_time.to_time.in_time_zone(time_zone)
        else
          recurrence_time
        end
      end
    end

    def add_recurrence_rule(rule)
      @schedule.add_recurrence_rule(rule)
    end

    def recurrence_rules
      @schedule.recurrence_rules
    end

    def occurrences_between(start_time, end_time)
      @schedule.occurrences_between(start_time.utc, end_time.utc)
    end

    def start_time
      @schedule.start_time.in_time_zone(time_zone)
    end

    def start_time=(time)
      @schedule.start_time = time.utc
    end

    def start_date
      @schedule.start_date
    end

    def next_occurrence
      @schedule.next_occurrence
    end

    def exception_times
      @schedule.exception_times
    end

    def remove_exception_time(time)
      @schedule.remove_exception_time(time.utc)
    end

    def add_exception_time(time)
      @schedule.add_exception_time(time.utc)
    end

    def exception_rules
      @schedule.exception_rules
    end

    def remove_recurrence_rule(rule)
      @schedule.remove_recurrence_rule(rule)
    end

    def remove_recurrence_day(day)
      new_schedule = @schedule
      recurrence_rule = new_schedule.recurrence_rules.first
      if recurrence_rule.present?
        new_schedule.remove_recurrence_rule(recurrence_rule)
        interval = recurrence_rule.to_hash[:interval]
        days = nil
        rule = case recurrence_rule
               when IceCube::WeeklyRule
                 days = recurrence_rule.to_hash[:validations][:day] || []

                 IceCube::Rule.weekly(interval).day(*(days - [day]))
               when IceCube::MonthlyRule
                 days = recurrence_rule.to_hash[:validations][:day_of_week].keys || []

                 monthly_days_hash = (days - [day]).inject({}) { |hash, day| hash[day] = [1]; hash }
                 IceCube::Rule.monthly(interval).day_of_week(monthly_days_hash)
               end

        if rule.present? && (days - [day]).present?
          new_schedule.add_recurrence_rule(rule)
          @schedule = new_schedule
        else
          @schedule = nil
        end
      else
        nil
      end
    end

    def remove_recurrence_times_on_day(day)
      day = DAYS[day] if day.is_a?(Integer) && day.between?(0, 6)
      new_schedule = @schedule
      new_schedule.recurrence_times.each do |recurrence_time|
        if recurrence_time.send("#{day}?") # recurrence_time.monday? for example
          new_schedule.remove_recurrence_time(recurrence_time)
        end
      end
      @schedule = new_schedule
    end

    def to_s
      @schedule.to_s
    end

    def ==(schedule)
      return false unless schedule.is_a?(Bucky::Schedule)
      self.to_hash == schedule.to_hash
    end

    def self.from_hash(hash)
      hash[:start_date] = hash.delete(:start_time) if hash[:start_time].present? #IceCube is moving away from 'date' but this one is still there.
      Bucky::Schedule.new(IceCube::Schedule.from_hash(hash))
    end

    private

    def ice_cube_schedule
      @schedule
    end
  end
end
