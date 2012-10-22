module Juscribe
  class Name
    attr_reader :first, :middle, :last

    class << self
      def convert(input)
        case input
        when String
          new(*input.split(/\s+/))
        end
      end
    end

    def initialize(first, *others, last)
      @first, @middle, @last = first, others.first, last
    end

    def middle_initial
      "#{middle.first}." if middle.present?
    end

    def first_and_last
      [first, *last].join(' ')
    end

    def full
      [first, *middle_initial, *last].join(' ')
    end

    def complete
      [first, *middle, *last].join(' ')
    end

    def to_s
      full
    end
  end
end