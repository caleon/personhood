module HaveErrorMatchers
  class HaveError
    def initialize(ya, *type_and_opts)
      @ya       = ya
      @options  = type_and_opts.extract_options!
      @type     = type_and_opts.shift || :invalid
    end

    def on(attribute)
      @attribute = attribute
      return self
    end

    def matches?(record)
      @record = record
      @record.send(:run_validations!) unless @options.delete(:skip_validate)
      @record.errors[@attribute].include?(@record.errors.generate_message(@attribute, @type, @options))
    end

    def failure_message_for_should
      "Expected #{@record.class.model_name.human} record to have an error of type :#@type for attribute #{@record.class.human_attribute_name(@attribute)}."
    end

    def failure_message_for_should_not
      "Expected #{@record.class.model_name.human} record to NOT have an error of type :#@type for attribute #{@record.class.human_attribute_name(@attribute)}."
    end

    def description
      ["have a :#@type validation error",
       *("on :#@attribute" if @attribute)].join(' ')
    end
  end

  def have_error(*type_and_opts)
    HaveError.new(true, *type_and_opts)
  end

  # RSpec::Matchers.define :have_error do |*type_and_opts|
  #   match do |actual|
  #     opts = type_and_opts.extract_options!
  #     type = type_and_opts.shift || :invalid
  #     actual.send(:run_validations!) unless opts.delete(:skip_validate)
  #     actual.errors # WIP
  #   end
  # end
end
