class CreateEvent < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :organization, foreign_key: true
      t.datetime :created_at
      t.string :hostname
      t.string :description
    end

    add_index :events,
              [:organization_id, :created_at],
              order: {created_at: :desc},
              name: 'most_recent_n_events'

    add_index :events,
              [:organization_id, :hostname, :created_at],
              order: {created_at: :desc},
              name: 'most_recent_n_events_for_hostname'
  end
end
