require 'cucumber/formatter/gherkin_formatter_adapter'
require 'cucumber/formatter/io'
require 'gherkin/formatter/argument'
require 'gherkin/formatter/json_formatter'
require 'time'

class Time
  # This will be loaded before timecop -- support files are loaded first and
  # are loaded in alphabetical order (hence the _ at the start of the filename)
  class << self
    alias_method :original_now, :now
  end
end

# Copy of cucumber/formatter/json, with defensive Time.now handling
module CircleCICucumberFormatter
  class CircleCIJson < Cucumber::Formatter::GherkinFormatterAdapter
    include Cucumber::Formatter::Io

    alias_method :original_before_step, :before_step

    def initialize(runtime, io, options)
      @io = ensure_io(io, "json")
      f = Gherkin::Formatter::JSONFormatter.new(@io)
      begin
        super(f, false, options)
      rescue ArgumentError # backwards compatibility with old arity
        super(f, false)
      end
    end

    # override @step_time with un-patched Time.now
    def before_step(step)
      original_before_step(step)
      @step_time = Time.original_now
    end

    # used for capturing duration, copied from gherkin_formatter_adapter.rb
    # override step_finish with un-patched Time.now
    def after_step(step)
      step_finish = (Time.original_now - @step_time)
      unless @outline and @options[:expand] and not @in_instantiated_scenario
        @gf.append_duration(step_finish)
      end
    end
  end
end
