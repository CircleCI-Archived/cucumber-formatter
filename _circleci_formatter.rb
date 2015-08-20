require 'cucumber/formatter/gherkin_formatter_adapter'
require 'cucumber/formatter/io'
require 'gherkin/formatter/argument'
require 'gherkin/formatter/json_formatter'
require 'time'

# Copy of cucumber/formatter/json, with defensive Time.now handling
module CircleCICucumberFormatter
  class CircleCIJson < Cucumber::Formatter::GherkinFormatterAdapter #:nodoc:
    include Cucumber::Formatter::Io

    alias_method :original_before_step, :before_step

    def unpatched_time_now
      if Time.respond_to?(:now_without_mock_time)
        Time.now_without_mock_time
      else
        Time.now
      end
    end

    def initialize(_runtime, io, options)
      @io = ensure_io(io, 'json')
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
      @step_time = unpatched_time_now
    end

    # used for capturing duration, copied from gherkin_formatter_adapter.rb
    # override step_finish with un-patched Time.now
    def after_step(_step)
      return if @outline && @options && @options[:expand] &&
                !@in_instantiated_scenario
      step_finish = (unpatched_time_now - @step_time)
      @gf.append_duration(step_finish)
    end
  end
end
