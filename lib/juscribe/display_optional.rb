module Juscribe # :nodoc:
  module DisplayOptional
    extend ActiveSupport::Concern

    included do
      class_attribute :unknown_label
      self.unknown_label = 'unnamed'
    end

    def to_s
      display_optional(to_param)
    end

    private
    def display_optional(value)
      value.blank? ? "(#{unknown_label})" : value
    end
  end
end
