# Require the necessary Ruby standard libraries
require 'rexml/document'

# This is a dependencies file.  It ensures that the dependent libraries are
# loaded only once, and that the expected version of the dependent libraries are
# loaded.
#
# == Primary Dependency
# * Savon (https://github.com/rubiii/savon) - Savon is a SOAP client library for
#   Ruby. It's goal is to provide a lightweight and easy to use alternative to
#   soap4r. If you're starting to use Savon, please make sure to read this guide
#   (http://rubiii.github.com/savon/) and make yourself familiar with SOAP
#   (http://www.w3.org/TR/soap/) itself, WSDL documents
#   (http://www.w3.org/TR/wsdl) and tools like soapUI (http://www.eviware.com/).
#
# == Savon's Dependencies
# Dependencies
# * Builder (https://github.com/rubiii/savon) - Provides a simple way to create
#   XML markup and data structures.
# * Crack (https://github.com/jnunemaker/crack) - Provides really simple JSON
#   and XML parsing, ripped from Merb and Rails.
# * Gyoku (https://github.com/rubiii/gyoku) - Provides simple translations from
#   Ruby Hashes to XML.
# * Httpi (https://github.com/rubiii/httpi) - HTTPI is an interface supporting
#   multiple HTTP libraries.
# * Rack (https://github.com/rack/rack) - Provides a modular Ruby web server
#   interface.

# Define the expected versions
expected_versions = {
  'builder' => '3.0.0',
  'crack' => '0.1.8',
  'gyoku' => '0.3.1',
  'httpi' => '0.7.9',
  'rack' => '1.2',
  'savon' => '0.8.6'
}

# Load the library unless it has already been loaded.
if not defined?(Builder)
  # Add the library path to the Ruby load path.  This ensures that the library
  # 'require' statements function as expected.
  $:.unshift "#{File.expand_path(File.dirname(__FILE__))}/vendor/builder-#{expected_versions['builder']}/lib"
  # Require the library
  require 'builder'
end

# Load the library unless it has already been loaded.
if not defined?(Crack)
  # Add the library path to the Ruby load path.  This ensures that the library
  # 'require' statements function as expected.
  $:.unshift "#{File.expand_path(File.dirname(__FILE__))}/vendor/crack-#{expected_versions['crack']}/lib"
  # Require the library
  require 'crack'
end

# Load the library unless it has already been loaded.
if not defined?(Gyoku)
  # Add the library path to the Ruby load path.  This ensures that the library
  # 'require' statements function as expected.
  $:.unshift "#{File.expand_path(File.dirname(__FILE__))}/vendor/gyoku-#{expected_versions['gyoku']}/lib"
  # Require the library
  require 'gyoku'
end

# Load the library unless it has already been loaded.
if not defined?(Rack)
  # Add the library path to the Ruby load path.  This ensures that the library
  # 'require' statements function as expected.
  $:.unshift "#{File.expand_path(File.dirname(__FILE__))}/vendor/rack-#{expected_versions['rack']}.1/lib"
  # Require the library
  require 'rack'
end

# Load the library unless it has already been loaded.
if not defined?(HTTPI)
  # Add the library path to the Ruby load path.  This ensures that the library
  # 'require' statements function as expected.
  $:.unshift "#{File.expand_path(File.dirname(__FILE__))}/vendor/httpi-#{expected_versions['httpi']}/lib"
  # Require the library
  require 'httpi'
end

# Load the library unless it has already been loaded.
if not defined?(Savon)
  # Add the library path to the Ruby load path.  This ensures that the library
  # 'require' statements function as expected.
  $:.unshift "#{File.expand_path(File.dirname(__FILE__))}/vendor/savon-#{expected_versions['savon']}/lib"
  # Require the library
  require 'savon'
end

# Define the list of versions
actual_versions = {
  'builder' => Builder::VERSION,
  'crack' => Crack::VERSION,
  'gyoku' => Gyoku::VERSION,
  'httpi' => HTTPI::VERSION,
  'rack' => Rack.release,
  'savon' => Savon::Version
}

# Check each of the versions
expected_versions.each do |library, expected_version|
  if expected_version != actual_versions[library]
    raise "Incompatible library version #{actual_versions[library]} for the " <<
      "#{library} library.  Expecting version #{expected_versions[library]}."
  end
end