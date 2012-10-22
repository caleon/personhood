module Juscribe # :nodoc:
  module TosAcceptable
    extend ActiveSupport::Concern

    included do
      validates :terms_of_service, acceptance: { accept: true }

      attr_accessor :tos_accepted, :tos_accepted_at
    end

    def tos_accepted=(val)
      self.tos_accepted_at = Time.now
    end

    def tos_accepted_at=(timestamp)
      write_attribute(:tos_accepted_at, timestamp) if has_attribute?(:tos_accepted_at)
      @_tos_accepted_at = timestamp
    end

    def tos_accepted?
      @_tos_accepted_at.try(:<, Time.now)
    end
    alias_method :tos_accepted,     :tos_accepted?
    alias_method :terms_of_service, :tos_accepted?
  end
end
