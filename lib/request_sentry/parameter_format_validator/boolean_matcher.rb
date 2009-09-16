module RequestSentry
  class ParameterFormatValidator
    class BooleanMatcher
      def matches?(value)
        %w(0 1 t f true false).include?(value)
      end
    end
  end
end