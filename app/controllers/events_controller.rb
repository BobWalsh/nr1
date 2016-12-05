class EventsController < ApplicationController

  def index
    events = if hostname = params[:hostname]
       Event.most_recent_by_hostname_and_org(org_id, hostname, count)
     else
       Event.most_recent_by_org(org_id, count)
     end
    render json: extract_events(events), status: :ok
  end

  def create
    event = Event.new(new_event_params)
    if event.save
      render json: event.as_json(except: :organization_id), status: :created
    end
  end

  private

  def org_id
    @org_id ||= params[:organization_id] # or throw error
  end

  def count
    @count ||= params[:count] || Event.count_by_org(org_id)
  end

  def extract_events(events)
    events.as_json(except: :organization_id)
  end

  def new_event_params
    {
      organization_id: event_params[:organization_id].to_i,
      description: event_params[:_json],
      hostname: request.env['REMOTE_HOST'] || request.env['REMOTE_ADDR']
    }
  end

  def event_params
    @event_params ||= params.permit(:organization_id, :_json)
  end
end
