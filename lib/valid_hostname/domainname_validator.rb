# frozen_string_literal: true

require 'valid_hostname/hostname_validator'

class DomainnameValidator < HostnameValidator
  def initialize(options)
    super({ require_valid_tld: true,
            allow_numeric_hostname: true }.merge(options))
  end

  def validate_each(record, attribute, value)
    super
    return unless value.is_a? String
    return if options[:allow_numeric_hostname] != true

    labels = value.split '.'
    is_numeric_only = labels[0] =~ /\A\d+\z/

    add_error record, attribute, :single_numeric_hostname_label if is_numeric_only && labels.size == 1
  end
end
