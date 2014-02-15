ExpediaHunt::Application.routes.draw do

  resources :temps

	root to: "searches#index"
	resources :searches do
		resources :flights
		member do
			post 'start'
		end
	end
end
