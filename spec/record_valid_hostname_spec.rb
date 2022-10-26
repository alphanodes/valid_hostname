# frozen_string_literal: true

require 'spec_helper'

describe Record do
  it 'valid with valid hostnames' do
    record = described_class.new name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test.org',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'valid with hostnames with hyphens' do
    record = described_class.new name: 't-est',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 't-est',
                                 name_with_wildcard: 't-est.org',
                                 name_with_valid_tld: 't-est.org',
                                 name_with_test_tld: 't-test.test',
                                 name_with_numeric_hostname: 't-est',
                                 name_with_blank: 't-est',
                                 name_with_nil: 't-est'

    expect(record).to be_valid
  end

  it 'valid with hostnames with underscores if option is true' do
    record = described_class.new name_with_underscores: '_test',
                                 name_with_wildcard: 'test.org',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid with hostnames with underscores if option is false' do
    record = described_class.new name_with_underscores: '_test',
                                 name_with_wildcard: '_test.org',
                                 name: '_test',
                                 name_with_valid_tld: '_test.org',
                                 name_with_test_tld: '_test.test',
                                 name_with_numeric_hostname: '_test',
                                 name_with_blank: '_test',
                                 name_with_nil: '_test'

    expect(record).not_to be_valid

    expect(record.errors).to have_key :name
    expect(record.errors).to have_key :name_with_valid_tld
    expect(record.errors).to have_key :name_with_test_tld
    expect(record.errors).to have_key :name_with_numeric_hostname
    expect(record.errors).to have_key :name_with_wildcard
    expect(record.errors).to have_key :name_with_blank
    expect(record.errors).to have_key :name_with_nil
  end

  it 'valid with hostnames with wildcard if option is true' do
    record = described_class.new name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_wildcard: '*.test.org',
                                 name_with_underscores: 'test.org',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid with hostnames with wildcard if option is false' do
    record = described_class.new name: '*.test',
                                 name_with_wildcard: '*.test.org',
                                 name_with_underscores: '*.test',
                                 name_with_valid_tld: '*.test.org',
                                 name_with_test_tld: '*.test.test',
                                 name_with_numeric_hostname: '*.test',
                                 name_with_blank: '*.test',
                                 name_with_nil: '*.test'

    expect(record).not_to be_valid

    expect(record.errors).to have_key :name
    expect(record.errors).to have_key :name_with_underscores
    expect(record.errors).to have_key :name_with_valid_tld
    expect(record.errors).to have_key :name_with_test_tld
    expect(record.errors).to have_key :name_with_numeric_hostname
    expect(record.errors).to have_key :name_with_blank
    expect(record.errors).to have_key :name_with_nil
  end

  it 'valid with blank hostname' do
    record = described_class.new name_with_blank: '',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_wildcard: 'test.org',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_underscores: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid with blank hostname' do
    record = described_class.new name: '',
                                 name_with_underscores: '',
                                 name_with_wildcard: '',
                                 name_with_valid_tld: '',
                                 name_with_test_tld: '',
                                 name_with_numeric_hostname: '',
                                 name_with_nil: '',
                                 name_with_blank: ''

    expect(record).not_to be_valid

    expect(record.errors).to have_key :name
    expect(record.errors).to have_key :name_with_underscores
    expect(record.errors).to have_key :name_with_wildcard
    expect(record.errors).to have_key :name_with_valid_tld
    expect(record.errors).to have_key :name_with_test_tld
    expect(record.errors).to have_key :name_with_numeric_hostname
    expect(record.errors).to have_key :name_with_nil
  end

  it 'valid with nil hostname' do
    record = described_class.new name_with_nil: nil,
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test.org',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test'

    expect(record).to be_valid
  end

  it 'valid when domain name length between 64 and 255' do
    long_labels = "#{'t' * 60}.#{'t' * 60}"
    record = described_class.new name: long_labels,
                                 name_without_verbose: 'test',
                                 name_with_underscores: long_labels,
                                 name_with_wildcard: long_labels,
                                 name_with_valid_tld: "#{long_labels}.org",
                                 name_with_test_tld: "#{long_labels}.test",
                                 name_with_numeric_hostname: long_labels,
                                 name_with_blank: long_labels,
                                 name_with_nil: long_labels

    expect(record).to be_valid
  end

  it 'invalid with too long hostname' do
    longname = ('t' * 256)
    record = described_class.new name: longname,
                                 name_with_underscores: longname,
                                 name_with_wildcard: longname,
                                 name_with_valid_tld: "#{longname}.org",
                                 name_with_test_tld: "#{longname}.test",
                                 name_with_numeric_hostname: longname,
                                 name_with_blank: longname,
                                 name_with_nil: longname

    expect(record).not_to be_valid

    expect(record.errors).to have_key :name
    expect(record.errors).to have_key :name_with_underscores
    expect(record.errors).to have_key :name_with_wildcard
    expect(record.errors).to have_key :name_with_valid_tld
    expect(record.errors).to have_key :name_with_test_tld
    expect(record.errors).to have_key :name_with_numeric_hostname
    expect(record.errors).to have_key :name_with_blank
    expect(record.errors).to have_key :name_with_nil
  end

  it 'invalid with too long hostname label' do
    long_labels = "#{'t' * 64}.#{'t' * 64}"
    record = described_class.new name: long_labels,
                                 name_with_underscores: long_labels,
                                 name_with_wildcard: long_labels,
                                 name_with_valid_tld: "#{long_labels}.org",
                                 name_with_test_tld: "#{long_labels}.test",
                                 name_with_numeric_hostname: long_labels,
                                 name_with_blank: long_labels,
                                 name_with_nil: long_labels

    expect(record).not_to be_valid
    expect(record.errors).to have_key :name
  end

  it 'invalid with invalid characters' do
    record = described_class.new
    %w[; : * ^ ~ + ' ! # " % & / ( ) = ? $ \\ ].each do |char|
      testname = "#{char}test"
      record.name                       = testname
      record.name_with_underscores      = testname
      record.name_with_wildcard         = testname
      record.name_with_valid_tld        = "#{testname}.org"
      record.name_with_test_tld         = "#{testname}.test"
      record.name_with_numeric_hostname = testname
      record.name_with_blank            = testname
      record.name_with_nil              = testname

      expect(record).not_to be_valid

      expect(record.errors).to have_key :name
      expect(record.errors).to have_key :name_with_underscores
      expect(record.errors).to have_key :name_with_wildcard
      expect(record.errors).to have_key :name_with_valid_tld
      expect(record.errors).to have_key :name_with_test_tld
      expect(record.errors).to have_key :name_with_numeric_hostname
      expect(record.errors).to have_key :name_with_blank
      expect(record.errors).to have_key :name_with_nil
    end
  end

  it 'invalid with hostname labels beginning with a hyphen' do
    record = described_class.new name: '-test',
                                 name_with_underscores: '-test',
                                 name_with_wildcard: '-test',
                                 name_with_valid_tld: '-test.org',
                                 name_with_test_tld: '-test.test',
                                 name_with_numeric_hostname: '-test',
                                 name_with_blank: '-test',
                                 name_with_nil: '-test'

    expect(record).not_to be_valid

    expect(record.errors).to have_key :name
    expect(record.errors).to have_key :name_with_underscores
    expect(record.errors).to have_key :name_with_wildcard
    expect(record.errors).to have_key :name_with_valid_tld
    expect(record.errors).to have_key :name_with_test_tld
    expect(record.errors).to have_key :name_with_numeric_hostname
    expect(record.errors).to have_key :name_with_blank
    expect(record.errors).to have_key :name_with_nil
  end

  it 'invalid with hostname labels ending with a hyphen' do
    record = described_class.new name: 'test-',
                                 name_with_underscores: 'test-',
                                 name_with_wildcard: 'test-',
                                 name_with_valid_tld: 'test-.org',
                                 name_with_test_tld: 'test-.test',
                                 name_with_numeric_hostname: 'test-',
                                 name_with_blank: 'test-',
                                 name_with_nil: 'test-'

    expect(record).not_to be_valid

    expect(record.errors).to have_key :name
    expect(record.errors).to have_key :name_with_underscores
    expect(record.errors).to have_key :name_with_wildcard
    expect(record.errors).to have_key :name_with_valid_tld
    expect(record.errors).to have_key :name_with_test_tld
    expect(record.errors).to have_key :name_with_numeric_hostname
    expect(record.errors).to have_key :name_with_blank
    expect(record.errors).to have_key :name_with_nil
  end

  it 'invalid hostnames with numeric only hostname labels' do
    record = described_class.new name: '12345',
                                 name_with_underscores: '12345',
                                 name_with_wildcard: '12345',
                                 name_with_valid_tld: '12345.org',
                                 name_with_test_tld: '12345.test',
                                 name_with_numeric_hostname: '0x12345',
                                 name_with_blank: '12345',
                                 name_with_nil: '12345'

    expect(record).not_to be_valid

    expect(record.errors).to have_key :name
    expect(record.errors).to have_key :name_with_underscores
    expect(record.errors).to have_key :name_with_wildcard
    expect(record.errors).to have_key :name_with_valid_tld
    expect(record.errors).to have_key :name_with_test_tld
    expect(record.errors).to have_key :name_with_blank
    expect(record.errors).to have_key :name_with_nil
  end

  it 'valid hostnames with numeric only hostname labels if option is true' do
    record = described_class.new name_with_numeric_hostname: '12345',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid hostnames with invalid tld if option is true' do
    record = described_class.new name_with_valid_tld: 'test.invalidtld',
                                 name: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :name_with_valid_tld
  end

  it 'valid hostnames with valid tld if option is true' do
    record = described_class.new name_with_valid_tld: 'test.org',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'valid hostnames with invalid tld if option is false' do
    record = described_class.new name: 'test.invalidtld',
                                 name_without_verbose: 'test.invalidtld',
                                 name_with_underscores: 'test.invalidtld',
                                 name_with_wildcard: 'test.invalidtld',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test.invalidtld',
                                 name_with_blank: 'test.invalidtld',
                                 name_with_nil: 'test.invalidtld'

    expect(record).to be_valid
  end

  it 'valid hostnames with tld from list' do
    record = described_class.new name_with_test_tld: 'test.test',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid hostnames with invalid tld from list' do
    record = described_class.new name_with_test_tld: 'test.invalidtld',
                                 name: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :name_with_test_tld
  end

  it 'invalid domainnames with single numeric hostname labels' do
    record = described_class.new domainname_with_numeric_hostname: '12345',
                                 name: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :domainname_with_numeric_hostname
  end

  it 'valid domainnames with numeric hostname labels' do
    record = described_class.new domainname_with_numeric_hostname: '12345.org',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid hostnames containing consecutive dots' do
    record = described_class.new name: 'te...st',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :name
  end

  it 'valid hostnames with trailing dot if option is true' do
    record = described_class.new name_with_valid_root_label: 'test.org.',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid hostnames with trailing dot if option is false' do
    record = described_class.new name_with_invalid_root_label: 'test.org.',
                                 name: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :name_with_invalid_root_label
  end

  it 'valid hostnames consisting of a single dot if option is true' do
    record = described_class.new name_with_valid_root_label: '.',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid hostnames consisting of a single dot' do
    record = described_class.new name_with_invalid_root_label: '.',
                                 name: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :name_with_invalid_root_label
  end

  it 'valid domainnames consisting of a single dot if option is true' do
    record = described_class.new domainname_with_valid_root_label: '.',
                                 name: 'test',
                                 name_without_verbose: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).to be_valid
  end

  it 'invalid domainnames consisting of a single dot' do
    record = described_class.new domainname_with_invalid_root_label: '.',
                                 name: 'test',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :domainname_with_invalid_root_label
  end

  it 'incorrect hostname without verbose' do
    record = described_class.new name: 'test',
                                 name_without_verbose: 'te..st',
                                 name_with_underscores: 'test',
                                 name_with_wildcard: 'test.org',
                                 name_with_valid_tld: 'test.org',
                                 name_with_test_tld: 'test.test',
                                 name_with_numeric_hostname: 'test',
                                 name_with_blank: 'test',
                                 name_with_nil: 'test'

    expect(record).not_to be_valid
    expect(record.errors).to have_key :name_without_verbose
  end
end
