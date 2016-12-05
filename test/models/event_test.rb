# == Schema Information
#
# Table name: events
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  created_at      :datetime
#  hostname        :string
#  description     :string
#

require 'test_helper'

class EventTest < ActiveSupport::TestCase
  describe 'scopes' do
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

    it 'by_org returns only events for an org' do
      extract_descriptions(Event.by_org(plain_org.id)).must_equal ['third'].to_s
    end

    it 'last_first returns events in reverse chronological order' do
      extract_descriptions(
        Event.last_first
      ).must_equal ['fourth', 'third', 'second', 'first'].to_s
    end

    it 'most_recent returns last "limit" events in reverse chronological order' do
      extract_descriptions(
        Event.most_recent(3)
      ).must_equal ['fourth', 'third', 'second'].to_s
    end

    it 'most_recent_by_org most_recent events for an org' do
      extract_descriptions(
        Event.most_recent_by_org(spiffy_org.id, 2)
      ).must_equal ['fourth', 'second'].to_s
    end

    it 'by_hostname returns only events for a hostname' do
      (descriptions(
         Event.by_hostname('spiff1.example.org')
       ) - ['first', 'third', 'fourth']).must_equal []
    end

    it 'by_hostname_and_org returns only events for a hostname within an org' do
      (descriptions(
         Event.by_hostname_and_org(spiffy_org.id, 'spiff1.example.org')
       ) - ['fourth', 'first']).must_equal []
    end

    it 'most_recent_by_hostname_and_org returns most recent events for a hostname within an org' do
      extract_descriptions(
        Event.by_hostname_and_org(spiffy_org.id, 'spiff1.example.org')
      ).must_equal ['fourth', 'first'].to_s
    end

  end
  
end
