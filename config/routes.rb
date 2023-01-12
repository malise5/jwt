Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :create] #create the user(signUpUser)
       post '/login', to: 'auth#create' #login for users with account
       get '/profile', to: 'users#profile' #profile
    end
  end
end
