module Juscribe # :nodoc:
  module Personhood
    extend ActiveSupport::Concern

    included do
      composed_of :name,  class_name:  'Juscribe::Name',
                          converter: :convert,
                          mapping: [%w(first_name  first),
                                    %w(middle_name middle),
                                    %w(last_name   last)]

      # rex_validate :last_name, :first_name, :middle_name
      with_options length: { maximum: 255 } do |x|
        x.validates :last_name, :first_name,  presence: true
        x.validates :middle_name
      end

      attr_accessible :last_name, :first_name, :middle_name, :name, :birthdate, :sex
      attr_accessible :last_name, :first_name, :middle_name, :name, :birthdate, :sex, :email, :username, as: :admin
    end

    # ----------------------------------------
    # :section: Basic Info
    # ----------------------------------------

    # Override the following to control what gets displayed on #to_s
    def to_param
      username
    end

    def middle_initial
      display_optional name.middle_initial
    end

    ##
    # Full name, unless empty, then shows "unnamed" variant.
    def full_name
      display_optional name.full
    end

    # Same as #full_name but omitting the middle_name.
    def first_and_last_name
      display_optional name.first_and_last
    end

    # Email, when the db field is nil, still returns an empty string,
    # I suppose for Devise's sake.
    def email_address
      "#{first_and_last_name} <#{email}>" if email.present?
    end

    # Defaults to <tt>Date.today</tt> if +nil+.
    def birthdate
      read_attribute(:birthdate) || Date.today
    end

    def age
      today, bday = Date.today, birthdate
      years       = today.year - bday.year
      years.tap { |yrs| yrs -= 1 if (bday + years.years) > today }
      # is this logic even solid?
    end

    def sex(format = nil)
      full_int = format == :full ? 1 : 0
      if read_attribute(:sex)
        %w(female male)[self[:sex]][0..full_int.send(:-@)]
      else
        %w{? (unknown)}[full_int]
      end
    end

    def male?
      sex == 'm'
    end

    def female?
      sex == 'f'
    end

    def androgynous?
      read_attribute(:sex).nil?
    end

    private
    def strip_names!
      %w(first_name middle_name last_name).each do |name_part|
        send(name_part).strip! if send(:"#{name_part}_changed?")
      end
    end

  end
end
