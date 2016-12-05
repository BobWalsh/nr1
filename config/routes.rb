Rails.application.routes.draw do
  get  'organizations/:organization_id/events', to: 'events#index'
  post 'organizations/:organization_id/events', to: 'events#create'
end
