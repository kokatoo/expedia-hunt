ExpediaHunt::Application.routes.draw do

	root to: "searches#index"
	resources :searches

end
