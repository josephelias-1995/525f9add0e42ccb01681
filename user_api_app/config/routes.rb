Rails.application.routes.draw do
  get 'api/typeahead/:input' => 'api/users#match_typeahead'
  namespace :api do
    resources :users
  end
end
