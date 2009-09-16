module RequestSentry
  class ParameterFormatValidator
    class ClassMatcher
      def initialize(klass)
        @klass = klass
      end

      def matches?(value)
        value.kind_of?(@klass)
      end
    end
  end
end