require 'request_sentry/parameter_format_validator'

module RequestSentry
  module ClassMethods
    # there are two different kind of accept_only validators.  Value, and class.
    # value validators check that the value is a string and that it conforms to certain formatting rules.
    # class validators check that a parameter is of the expected class.
    #
    # Value validators:
    #     accept_only :number, :for => :account_balance                     # allow any number, positive or negative, with or without decimal places
    #     accept_only :unsigned_number, :for => :deposit_amount             # don't allow negative numbers
    #     accept_only :integer, :for => :days_until_launch                  # don't allow numbers with decimal places
    #     accept_only :unsigned_integer, :for => :age                       # don't allow negative numbers or decimal places.
    #     accept_only :boolean, :for => [:wants_newsletter, :email_alerts]  # allow only boolean input values, '1', '0', 'true', 'false'
    #     accept_only :date, :for => [:from_date, :to_date]                 # allow only date values
    #     accept_only /\d{3}\-\d{3}\-\d{4}/, :for => :phone                 # use a regexp to define param validation conditions!
    #
    # Class validators:
    #     accept_only :string, :for => :first_name
    #     accept_only :hash, :for => :selected_categories
    #     accept_only :array, :for => :my_postal_codes
    #
    def accept_only(param_type, options)
      raise "Must pass in options[:for]" if options[:for].blank?

      validator = ParameterFormatValidator.new param_type
      param_names = [options[:for]].flatten
      before_filter do |controller|
        param_names.each do |param_name|
          unless validator.valid?(controller.params[param_name])
            controller.send(:render_optional_error_file, 400) and return
          end
        end
      end
    end
  end

  def self.included(base)
    base.extend ClassMethods
  end
end