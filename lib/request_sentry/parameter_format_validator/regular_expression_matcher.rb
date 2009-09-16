module RequestSentry
  class ParameterFormatValidator
    class RegularExpressionMatcher
      def initialize(regex)
        @regex = regex
      end

      def matches?(value)
        !!(@regex =~ value)
      end
    end
  end
end