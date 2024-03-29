ChessCamp::Application.routes.draw do
  # generated routes
  resources :curriculums
  resources :instructors
  resources :camps
  resources :families
  resources :locations
  resources :students
  resources :sessions
  resources :registrations

  # semi-static routes
  get 'home', to: 'home#index', as: :home
  get 'home/about', to: 'home#about', as: :about
  get 'home/contact', to: 'home#contact', as: :contact
  get 'home/privacy', to: 'home#privacy', as: :privacy
  get 'home/camp_summary/:id', to: 'home#camp_summary', as: :camp_summary
  get 'home/dashboard', to: 'home#dashboard', as: :dashboard
  get 'home/dashboard/report', to: 'home#report', as: :report
  match 'home/dashboard', to: 'home#report', via: :post
  
  get 'login', to: 'sessions#new', as: :login
  get 'logout', to: 'sessions#destroy', as: :logout
  
  # set the root url
  root to: 'home#index'

end
