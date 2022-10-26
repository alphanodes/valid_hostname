# frozen_string_literal: true

require 'valid_hostname/version'
require 'valid_hostname/validate_hostname'

require 'valid_hostname/hostname_validator'
require 'valid_hostname/domainname_validator'

require 'debug' if ENV['ENABLE_DEBUG']

I18n.load_path += Dir.glob File.expand_path('../config/locales/**/*', __dir__)

module ValidHostname
end
