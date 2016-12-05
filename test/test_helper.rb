ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  def json(response)
    JSON.parse(response.body, symbolize_names: true)
  end

  def descriptions(events)
    events.collect { |e| e[:description] }
  end

  def extract_descriptions(events)
    descriptions(events).to_s
  end
end
