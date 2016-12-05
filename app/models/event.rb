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

class Event < ApplicationRecord
  belongs_to :organization

  validates :organization, :hostname, :description, presence: true

  scope :by_org, ->(org_id) { where(organization_id: org_id) }
  scope :count_by_org, ->(org_id) { by_org(org_id).count }

  scope :last_first, -> { order(created_at: :desc) }

  scope :most_recent, ->(limit) { last_first.limit(limit) }
  scope :most_recent_by_org, ->(org_id, limit) { by_org(org_id).most_recent(limit) }

  scope :by_hostname, ->(fqdn) { where(hostname: fqdn) }
  scope :by_hostname_and_org, ->(org_id, fqdn) { by_org(org_id).by_hostname(fqdn) }

  scope :most_recent_by_hostname_and_org, ->(org_id, fqdn, limit) {
    by_hostname_and_org(org_id, fqdn).most_recent(limit)
  }
end
