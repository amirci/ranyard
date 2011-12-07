PrdcRor::Application.routes.draw do
  
  resources :speakers
  resources :conferences
  resources :events
  resources :sponsors, :only => [:index]
  
  get 'last_update' => "conferences#last_update"
  
  resources :sessions do
    collection do 
      get 'attendance'
    end
    
    member do
      post 'attending', as: 'planning_to_attend'
      post 'not_attending', as: 'planning_not_to_attend'
    end
  end

  resource :schedule, :only => [:show, :edit], :controller => :schedule
  
  match "/schedule/days/:id" => "schedule#days"
  
  
  resources :accounts, :only => :create
  get  "log_in"  => "accounts#new"    
  get  "log_out" => "accounts#destroy"
      
  match "admin" => 'conferences#index'

  #disabled temporarily as we figure out how best to serve pdfs from heroku
  #match 'files/:file_name.:file_format' => 'files#download'

  post 'west' => 'info_requests#create', :as => 'info_requests'

  get 'reports/info' => 'reports#info', :as => 'report_info'

  # catch all simple /:id routes that have not previously
  #   matched and route them through the high_voltage 
  #   pages controller
  match ':id' => 'pages#show', as: 'page'
  
  root :to => 'pages#show', :defaults => {:id => 'home'}
  
  # any error in routing goes to the home
  match '*a', :to => 'pages#home'
end
