require 'request_sentry/parameter_format_validator/regular_expression_matcher'
require 'request_sentry/parameter_format_validator/boolean_matcher'
require 'request_sentry/parameter_format_validator/date_matcher'
require 'request_sentry/parameter_format_validator/class_matcher'

module RequestSentry
  class ParameterFormatValidator
    def initialize(param_type)
      if Regexp === param_type
        @matcher = RegularExpressionMatcher.new param_type
      else
        @param_type = param_type
      end
    end

    @@matchers = {
      # (string) value matchers
      :number => RegularExpressionMatcher.new(/^[\+\-]?\d+(\.\d+)?$/),
      :unsigned_number => RegularExpressionMatcher.new(/^[\+]?\d+(\.\d+)?$/),
      :integer => RegularExpressionMatcher.new(/^[\+\-]?\d+$/),
      :unsigned_integer => RegularExpressionMatcher.new(/^[\+]?\d+$/),
      :boolean => BooleanMatcher.new,
      :date => DateMatcher.new,
      # class matchers
      :string => ClassMatcher.new(String),
      :hash => ClassMatcher.new(Hash),
      :array => ClassMatcher.new(Array)
    }

    def valid?(value)
      raise "There is no RequestSentry param type called #{@param_type}. Check class docs." unless matcher
      case matcher
      when ClassMatcher
        value.nil? || matcher.matches?(value)
      else
        value.nil? || (value.kind_of?(String) && (value.empty? || matcher.matches?(value)))
      end
    end

    private
    def matcher
      @matcher || @@matchers[@param_type]
    end
  end
end