# frozen_string_literal: true

class ValidateHostname
  class << self
    def allowed_tlds
      @allowed_tlds ||= begin
        config = File.expand_path '../../config/valid_hostname.yml', __dir__
        YAML.load_file(config)['allowed_tlds']
      end
    end

    def allowed_characters(allow_underscore: false)
      valid_chars = +'a-z0-9\-'
      valid_chars << '_' if allow_underscore
      valid_chars
    end

    # use for valid?
    def default_options
      { allow_underscore: false,
        require_valid_tld: false,
        allow_numeric_hostname: false,
        allow_wildcard_hostname: false,
        allow_root_label: false,
        verbose: true }
    end

    def valid?(value, user_options = nil)
      value ||= ''

      # works with ruby 2.7 and => 3
      options = ValidateHostname.default_options.merge(user_options || {})

      valid_length?(value) &&
        valid_label_length?(value) &&
        valid_hyphens?(value) &&
        valid_dots?(value) &&
        valid_trailing_dot?(value,
                            allow_root_label: options[:allow_root_label]) &&
        valid_characters?(value,
                          allow_underscore: options[:allow_underscore],
                          allow_wildcard_hostname: options[:allow_wildcard_hostname]) &&
        valid_numeric_only?(value,
                            allow_numeric_hostname: options[:allow_numeric_hostname]) &&
        valid_tld?(value,
                   valid_tlds: nil, require_valid_tld: options[:require_valid_tld])
    end

    def valid_length?(value)
      return false unless check_string value

      value.length.between? 1, 255
    end

    def valid_label_length?(value)
      return false unless check_string value

      labels = value.split '.'
      labels.each do |label|
        return false unless label.length.between? 1, 63
      end

      true
    end

    def valid_hyphens?(value)
      labels = value.split '.'
      labels.each do |label|
        return false if label =~ /^-/i || label =~ /-$/
      end

      true
    end

    # hostname can only contain characters:
    # a-z, 0-9, hyphen, optional underscore, optional asterisk
    def valid_characters?(value, allow_underscore: false, allow_wildcard_hostname: false)
      return true unless check_string value

      valid_chars = allowed_characters allow_underscore: allow_underscore
      labels = value.split '.'
      labels.each_with_index do |label, index|
        # Take care of wildcard first label
        next if allow_wildcard_hostname && label == '*' && index.zero?
        next if /\A[#{valid_chars}]+\z/i.match?(label)

        return false
      end

      true
    end

    # the unqualified hostname portion cannot consist of numeric values only
    def valid_numeric_only?(value, allow_numeric_hostname: false)
      return true if allow_numeric_hostname == true
      return true unless check_string value

      first_label = value.split('.').first
      first_label !~ /\A\d+\z/
    end

    # hostname may not contain consecutive dots
    def valid_dots?(value)
      !/\.\./.match?(value)
    end

    def valid_trailing_dot?(value, allow_root_label: false)
      return true if allow_root_label != false
      return true unless check_string value

      value[-1] != '.'
    end

    def valid_tld?(value, valid_tlds: nil, require_valid_tld: true)
      return true if !check_string(value) || value == '.'
      return true if require_valid_tld != true

      labels = value.split '.'
      return true if labels.count.zero?
      return false if valid_tlds && valid_tlds.empty?

      valid_tlds = valid_tlds.nil? ? allowed_tlds : valid_tlds.map(&:downcase)
      valid_tlds.include? labels.last.downcase
    end

    private

    def check_string(value)
      value.is_a?(String) && !value.empty?
    end
  end
end
