# frozen_string_literal: true

require 'active_model'
require 'active_model/validations'
require 'valid_hostname/validate_hostname'

class HostnameValidator < ActiveModel::EachValidator
  def initialize(options)
    super(ValidateHostname.default_options.merge(options))
  end

  def validate_each(record, attribute, value)
    value ||= ''

    if options[:verbose]
      add_error record, attribute, :invalid_hostname_length unless ValidateHostname.valid_length? value
      add_error record, attribute, :hostname_contains_consecutive_dots unless ValidateHostname.valid_dots? value

      unless ValidateHostname.valid_trailing_dot?(value,
                                                  allow_root_label: options[:allow_root_label])
        add_error record, attribute, :hostname_ends_with_dot
      end

      unless ValidateHostname.valid_tld? value, valid_tlds: options[:valid_tlds], require_valid_tld: options[:require_valid_tld]
        add_error record, attribute, :hostname_is_not_fqdn
      end

      return unless value.is_a? String

      add_error record, attribute, :invalid_label_length unless ValidateHostname.valid_label_length? value
      add_error record, attribute, :label_begins_or_ends_with_hyphen unless ValidateHostname.valid_hyphens? value

      unless ValidateHostname.valid_characters?(value,
                                                allow_underscore: options[:allow_underscore],
                                                allow_wildcard_hostname: options[:allow_wildcard_hostname])
        add_error record,
                  attribute,
                  :label_contains_invalid_characters,
                  valid_chars: ValidateHostname.allowed_characters(allow_underscore: options[:allow_underscore])
      end

      unless ValidateHostname.valid_numeric_only? value, allow_numeric_hostname: options[:allow_numeric_hostname]
        add_error record, attribute, :hostname_label_is_numeric
      end
    elsif !ValidateHostname.valid? value, **options
      record.errors.add attribute, options[:message].nil? ? I18n.t(:invalid, scope: 'activerecord.errors.messages') : options[:message]
    end
  end

  private

  def add_error(record, attribute, message_key, *interpolators)
    args = { default: [message_key, options[:message]],
             scope: %i[errors messages hostname] }.merge(interpolators.last.is_a?(Hash) ? interpolators.pop : {})

    record.errors.add attribute, I18n.t(message_key, **args)
  end
end
