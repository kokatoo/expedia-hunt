ExpediaHunt::Application.routes.draw do
  root to: "expedias#index"

  resources "expedias"
end
