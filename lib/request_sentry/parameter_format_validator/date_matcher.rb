module RequestSentry
  class ParameterFormatValidator
    class DateMatcher
      def matches?(value)
        !!Date.parse(value) rescue false
      end
    end
  end
end