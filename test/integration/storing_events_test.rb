require 'test_helper'

class StoringEventsTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  let(:spiffy_org) { Organization.create!(name: 'spiffy') }
    
  let(:description) { 'first' }
  let(:hostname) { 'spiff1.example.org' }

  it 'creates an event for the organization' do
    post "/organizations/#{spiffy_org.id}/events",
         params: description,
         headers: { 'Content-Type' => 'application/json',
                    'REMOTE_HOST' => 'spiff1.example.org' },
         as: :json

    response.status.must_equal 201
    response.content_type.must_equal Mime[:json]

    event = json(response)
    event[:description].must_equal description
    event[:hostname].must_equal hostname
    
    # a better test for this would use timecop (https://rubygems.org/gems/timecop)
    # but we're timeboxing this challenge
    event[:created_at].wont_be_nil
  end
end
  
