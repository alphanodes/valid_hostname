# frozen_string_literal: true

require 'spec_helper'

describe ValidateHostname do
  context 'with valid?' do
    it 'valid single label' do
      expect(described_class).to be_valid('test')
    end

    it 'valid multiple labels' do
      expect(described_class).to be_valid('test1.test2.com')
    end

    it 'valid label length' do
      expect(described_class).not_to be_valid("my#{'t' * 62}.hostname")
    end

    it 'invalid hostname length' do
      expect(described_class).not_to be_valid("my#{'t' * 254}.hostname")
    end

    it 'valid hyphens' do
      expect(described_class).to be_valid('my-host.hostname')
    end

    it 'invalid hyphens' do
      expect(described_class).not_to be_valid('-myhost.hostname')
      expect(described_class).not_to be_valid('myhost-.hostname')
      expect(described_class).not_to be_valid('-myhost-.hostname')
      expect(described_class).not_to be_valid('myhost.-hostname')
    end

    it 'invalid root label' do
      expect(described_class).not_to be_valid('.')
      expect(described_class).not_to be_valid('test.')
    end

    it 'valid root label with allow_root_label' do
      expect(described_class).to be_valid('.', allow_root_label: true)
      expect(described_class).to be_valid('test.', allow_root_label: true)
    end
  end

  context 'with valid_length?' do
    it 'valid hostname length' do
      expect(described_class).to be_valid_length("my#{'t' * 253}")
    end

    it 'invalid hostname length' do
      expect(described_class).not_to be_valid_length("my#{'t' * 254}")
      expect(described_class).not_to be_valid_length('')
      expect(described_class).not_to be_valid_length(nil)
    end
  end

  context 'with valid_label_length?' do
    it 'valid label length' do
      expect(described_class).to be_valid_label_length("my#{'t' * 61}.hostname")
    end

    it 'invalid label length' do
      expect(described_class).not_to be_valid_label_length("my#{'t' * 62}.hostname")
      expect(described_class).not_to be_valid_label_length('')
      expect(described_class).not_to be_valid_label_length(nil)
    end
  end

  context 'with valid_hyphens?' do
    it 'valid hyphens' do
      expect(described_class).to be_valid_hyphens('my-host.hostname')
    end

    it 'invalid hyphens' do
      expect(described_class).not_to be_valid_hyphens('-myhost.hostname')
      expect(described_class).not_to be_valid_hyphens('myhost-.hostname')
      expect(described_class).not_to be_valid_hyphens('-myhost-.hostname')
      expect(described_class).not_to be_valid_hyphens('myhost.-hostname')
      expect(described_class).not_to be_valid_hyphens("\n-myhost.hostname")
      expect(described_class).not_to be_valid_hyphens("myhost.\n-hostname")
      expect(described_class).not_to be_valid_hyphens("myhost.hostname-\n")
    end
  end

  context 'with valid_numeric_only?' do
    it 'valid numeric only' do
      expect(described_class).to be_valid_numeric_only('my-host.hostname', allow_numeric_hostname: true)
      expect(described_class).to be_valid_numeric_only('1234.hostname', allow_numeric_hostname: true)
      expect(described_class).to be_valid_numeric_only('test.1234.hostname')
      expect(described_class).to be_valid_numeric_only('')
      expect(described_class).to be_valid_numeric_only(nil)
    end

    it 'invalid numeric only' do
      expect(described_class).not_to be_valid_numeric_only('1234.hostname')
    end
  end

  context 'with valid_dots?' do
    it 'valid dots' do
      expect(described_class).to be_valid_dots('test.hostname')
      expect(described_class).to be_valid_dots('')
      expect(described_class).to be_valid_dots(nil)
    end

    it 'invalid dots' do
      expect(described_class).not_to be_valid_dots('1234..hostname')
      expect(described_class).not_to be_valid_dots('hostname..')
      expect(described_class).not_to be_valid_dots('..hostname')
    end
  end

  context 'with valid_characters?' do
    it 'valid characters' do
      expect(described_class).to be_valid_characters('localhost')
      expect(described_class).to be_valid_characters('localhost.domain1')
      expect(described_class).to be_valid_characters('localhost.dom-ain1')
      expect(described_class).to be_valid_characters('')
      expect(described_class).to be_valid_characters(nil)
      expect(described_class).to be_valid_characters('test.host_name', allow_underscore: true)
      expect(described_class).to be_valid_characters('*.domain1', allow_wildcard_hostname: true)
    end

    it 'invalid characters' do
      expect(described_class).not_to be_valid_characters('test.host_name')
      expect(described_class).not_to be_valid_characters('*.domain1')
      expect(described_class).not_to be_valid_characters('localhost.tes,t')
      expect(described_class).not_to be_valid_characters('localhost.tes;t')
      expect(described_class).not_to be_valid_characters('localhost.teßt')
      expect(described_class).not_to be_valid_characters("localhost\n.test")
    end
  end

  context 'with valid_tld?' do
    it 'valid tlds' do
      expect(described_class).to be_valid_tld('test.org')
      expect(described_class).to be_valid_tld('test.ccc', valid_tlds: ['ccc'])
      expect(described_class).to be_valid_tld('test.ccc', require_valid_tld: false)
      expect(described_class).to be_valid_tld('')
      expect(described_class).to be_valid_tld(nil)
    end

    it 'invalid tlds' do
      expect(described_class).not_to be_valid_tld('test.ccc')
      expect(described_class).not_to be_valid_tld('test')
    end
  end
end
