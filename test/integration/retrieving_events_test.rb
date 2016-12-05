require 'test_helper'

class RetrievingEventsTest < ActionDispatch::IntegrationTest
  setup { host! 'api.example.com' }

  let(:spiffy_org) { Organization.create!(name: 'spiffy') }
  let(:plain_org) { Organization.create!(name: 'plain') }

  let!(:events) {
    Event.create!(
      [
        {organization: spiffy_org, hostname: 'spiff1.example.org', description: 'first'},
        {organization: spiffy_org, hostname: 'spiff3.example.org', description: 'second'},
        {organization: plain_org, hostname: 'spiff1.example.org', description: 'third'},
        {organization: spiffy_org, hostname: 'spiff1.example.org', description: 'fourth'},
      ]
    )
  }

  it 'returns only the event information' do
    get "/organizations/#{spiffy_org.id}/events", as: :json

    response.status.must_equal 200
    response.content_type.must_equal Mime[:json]

    events = json(response)
    (events.first.keys - [:created_at, :hostname, :description, :id]).must_equal []
  end

  it 'returns most recent N events for an org in reverse chronological order' do
    get "/organizations/#{spiffy_org.id}/events?count=2"

    response.status.must_equal 200
    response.content_type.must_equal Mime[:json]

    extract_descriptions(json(response)).must_equal ['fourth', 'second'].to_s
  end

  it 'returns most recent N events by hostname for an org in reverse chronological order' do
    get "/organizations/#{spiffy_org.id}/events?count=2&hostname=spiff3.example.org"

    response.status.must_equal 200
    response.content_type.must_equal Mime[:json]

    extract_descriptions(json(response)).must_equal ['second'].to_s
  end
end
